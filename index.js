import { NativeModules, Platform } from "react-native";
const { TextRecognition } = NativeModules;

export function recognizeFromImage(path) {
  if (Platform.OS !== "ios") {
    return Promise.reject(new Error("Only iOS is supported."));
  }
  return TextRecognition.recognizeFromImage(path);
}

export default {
  recognizeFromImage,
};
