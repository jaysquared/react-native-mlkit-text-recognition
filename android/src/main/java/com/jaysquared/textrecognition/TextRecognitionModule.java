package com.jaysquared.textrecognition;

import android.net.Uri;
import androidx.annotation.NonNull;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;
import com.google.mlkit.vision.common.InputImage;
import com.google.mlkit.vision.text.Text;
import com.google.mlkit.vision.text.TextRecognition;
import com.google.mlkit.vision.text.TextRecognizer;
import java.io.File;

@ReactModule(name = TextRecognitionModule.NAME)
public class TextRecognitionModule extends ReactContextBaseJavaModule {
  public static final String NAME = "TextRecognition";
  private final TextRecognizer recognizer;

  public TextRecognitionModule(ReactApplicationContext reactContext) {
    super(reactContext);
    recognizer = TextRecognition.getClient();
  }

  @NonNull
  @Override
  public String getName() {
    return NAME;
  }

  @ReactMethod
  public void recognizeFromImage(String path, Promise promise) {
    try {
      File file = new File(path);
      InputImage image = InputImage.fromFilePath(getReactApplicationContext(), Uri.fromFile(file));
      recognizer.process(image)
        .addOnSuccessListener(result -> promise.resolve(result.getText()))
        .addOnFailureListener(error -> promise.reject("E_RECOGNIZE_FAIL", error));
    } catch (Exception e) {
      promise.reject("E_NO_IMAGE", e);
    }
  }
}