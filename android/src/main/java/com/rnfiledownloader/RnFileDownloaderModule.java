package com.rnfiledownloader;

import androidx.annotation.NonNull;
import android.os.Environment;
import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;

import org.json.JSONObject;

import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

@ReactModule(name = RnFileDownloaderModule.NAME)
public class RnFileDownloaderModule extends ReactContextBaseJavaModule {
    public static final String NAME = "RnFileDownloader";

    public RnFileDownloaderModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    @NonNull
    public String getName() {
        return NAME;
    }

  @ReactMethod
  public void downloadFile(String uri, String filename, String headers, Promise promise) {
    Log.d("FileDownloaderModule", "Try to download: " + uri);
    int count;
    try {
      JSONObject jsonObject = new JSONObject(headers);
      URL object = new URL(uri);
      HttpURLConnection connection = (HttpURLConnection) object.openConnection();
      connection.setReadTimeout(60 * 1000);
      connection.setConnectTimeout(60 * 1000);
      String bearerAuth = jsonObject.getString("Authorization");
      connection.setRequestProperty("Authorization", bearerAuth);
      int responseCode = connection.getResponseCode();

      if (responseCode == 200) {
        Log.d("FileDownloaderModule", "Downloaded to : " + Environment.getExternalStorageDirectory().toString());
        InputStream input = connection.getInputStream();
        OutputStream output = new FileOutputStream(Environment
          .getExternalStorageDirectory().toString()
          + "/Download/" + filename);

        byte[] data = new byte[2048];

        while ((count = input.read(data)) != -1) {
          output.write(data, 0, count);
        }

        output.flush();
        output.close();
        input.close();

        promise.resolve("/Download/" + filename);

      }

    } catch (Exception e) {
      e.printStackTrace();
      Log.e("Error: ", e.getMessage());
      promise.reject("Erreur téléchargement ", e);
    }
  }
}
