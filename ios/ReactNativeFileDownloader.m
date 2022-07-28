// ReactNativeFileDownloader.m

#import "ReactNativeFileDownloader.h"
#import <React/RCTLog.h>

@implementation ReactNativeFileDownloader
RCT_EXPORT_MODULE();


RCT_EXPORT_METHOD(downloadFile:(NSString *)url
                  filename:(NSString *)filename
                  headers:(NSString *)headers
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    RCTLogInfo(@"FileDownloaderRestApiModule : Try to download %@", url);

    NSError *e = nil;
    NSData *data = [headers dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options:  NSJSONReadingMutableContainers error: &e];

    if (!jsonArray) {
        NSLog(@"FileDownloaderRestApiModule Error parsing JSON: %@", e);
    }

    NSString *bearer = [jsonArray valueForKey:@"Authorization"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request addValue:bearer forHTTPHeaderField:@"Authorization"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
        NSHTTPURLResponse *httpresponse = (NSHTTPURLResponse *) response;
        long statusCode = (long)[httpresponse statusCode];
        if (!error && statusCode == 200) {
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,filename];
            [data writeToFile:filePath atomically:YES];
            resolve([@"/Documents/Officiels/" stringByAppendingString:filename]);
        } else {
            NSLog(@"FileDownloaderRestApiModule Error téléchargement %ld", statusCode);
            reject(@"Erreur téléchargement ", @"", nil);
        }
    }] resume];
}
@end
