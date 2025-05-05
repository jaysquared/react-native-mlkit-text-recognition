#import "RCTTextRecognitionModule.h"

// these bring in the recognizer and the VisionImage type
@import MLKitTextRecognition;
@import MLKitVision;

// **this** brings in MLKText and its properties
@import MLKitTextRecognitionCommon;

@implementation RCTTextRecognitionModule

RCT_EXPORT_MODULE(TextRecognition);

RCT_REMAP_METHOD(recognizeFromImage,
                 recognizeFromImageWithPath:(NSString *)imagePath
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  NSURL *fileURL = [NSURL URLWithString:imagePath];
NSData *data = [NSData dataWithContentsOfURL:fileURL];
UIImage *image = [UIImage imageWithData:data];
if (!image) {
  reject(@"E_NO_IMAGE", @"Failed to load image at path", nil);
  return;
}

  // the new v2 API wants options, not the old deprecated factory
  MLKTextRecognizerOptions *options = [[MLKTextRecognizerOptions alloc] init];
  MLKTextRecognizer *recognizer = [MLKTextRecognizer textRecognizerWithOptions:options];

  MLKVisionImage *visionImage = [[MLKVisionImage alloc] initWithImage:image];

  [recognizer processImage:visionImage
                completion:^(MLKText *_Nullable result, NSError *_Nullable error) {
    if (error != nil || result == nil) {
      reject(@"E_RECOGNIZE_FAIL", error.localizedDescription, error);
      return;
    }
    resolve(result.text);
  }];
}

@end
