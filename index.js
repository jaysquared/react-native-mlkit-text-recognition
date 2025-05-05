import { Platform, NativeModules } from "react-native";
const { TextRecognition } = NativeModules;

export function recognizeFromImage(path) {
  if (!path) throw new Error("Path is required");
  if (Platform.OS === "ios") {
    return TextRecognition.recognizeFromImage(path);
  } else if (Platform.OS === "android") {
    return TextRecognition.recognizeFromImage(path);
  }
  return Promise.reject(new Error("Unsupported platform"));
}

export default { recognizeFromImage };
