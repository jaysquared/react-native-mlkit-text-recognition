Pod::Spec.new do |s|
  s.name             = "TextRecognition"
  s.version          = "1.0.0"
  s.summary          = "React Native bridge for MLKit Text Recognition"
  s.license          = { :type => "MIT" }
  s.author           = { "Your Name" => "you@example.com" }
  s.homepage         = "https://github.com/jaysquared/react-native-mlkit-text-recognition"
  s.platform         = :ios, "13.0"
  s.source           = { :git => s.homepage, :tag => s.version }

  s.source_files     = "ios/**/*.{h,m}"
  s.dependency       "GoogleMLKit/TextRecognition", ">= 8.0.0"
  s.dependency       "React-Core"
end