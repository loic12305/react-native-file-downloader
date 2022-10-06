import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'rn-file-downloader' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const RnFileDownloader = NativeModules.RnFileDownloader
  ? NativeModules.RnFileDownloader
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function downloadFile(
  url: string,
  filename: string,
  headers: string
): Promise<string> {
  return RnFileDownloader.downloadFile(url, filename, headers);
}
