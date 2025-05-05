#import "RCTTextRecognitionModule.h"
@import MLKitTextRecognition;

@implementation RCTTextRecognitionModule

RCT_EXPORT_MODULE(TextRecognition);

// Expose method to JS
RCT_REMAP_METHOD(recognizeFromImage,
                 recognizeFromImageWithPath:(NSString *)imagePath
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
  if (!image) {
    reject(@"E_NO_IMAGE", @"Failed to load image at path", nil);
    return;
  }

  MLKTextRecognizer *recognizer = [MLKTextRecognizer textRecognizer];
  MLKVisionImage *visionImage = [[MLKVisionImage alloc] initWithImage:image];
  [recognizer processImage:visionImage
                  completion:^(MLKText *_Nullable result, NSError *_Nullable error) {
    if (error != nil || result == nil) {
      reject(@"E_RECOGNIZE_FAIL", error.localizedDescription, error);
      return;
    }

    // Gather recognized text
    NSString *fullText = result.text;
    resolve(fullText);
  }];
}

@end