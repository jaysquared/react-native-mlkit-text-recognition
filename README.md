# react-native-mlkit-text-recognition

A cross-platform React Native bridge for Google MLKit Text Recognition (iOS v8.x & Android ML Kit v16.x).

## 📦 Installation

Install the package and update your iOS pods:

```bash
yarn add react-native-mlkit-text-recognition
cd ios && pod install --repo-update
```

## 🔧 iOS Configuration

> **⚠️ Note:** The `MLKitTextRecognitionCommon` framework currently contains an embargoed domain (`nic.ir.md`) which may cause App Store rejections. Apply the following patch in your `Podfile` until Google releases an upstream fix.

1. Open your `ios/Podfile` and add (or update) the `post_install` hook at the **top level**:

   ```ruby
   post_install do |installer|
     # Path to the MLKit binary
     bin_path = (
       installer.sandbox.root +
       'MLKitTextRecognitionCommon/Frameworks/MLKitTextRecognitionCommon.framework/' +
       'MLKitTextRecognitionCommon'
     ).to_s

     puts '🔍 Patching MLKitTextRecognitionCommon for embargoed domains...'

     patch_script = <<~BASH
       #!/usr/bin/env bash
       BINARY="#{bin_path}"
       if [ ! -f "$BINARY" ]; then
         echo "⚠️  Binary not found at $BINARY, skipping patch."
         exit 0
       fi

       # Zero-out all occurrences of the forbidden domain
       grep -aob 'nic\\.ir\\.md' "$BINARY" | \
       while IFS=: read -r offset match; do
         count=${#match}
         echo "  • Zeroing out $count bytes at offset $offset"
         dd if=/dev/zero bs=1 count=$count seek=$offset \
           of="$BINARY" conv=notrunc >/dev/null 2>&1
       done

       # Re-sign the framework
       FRAMEWORK_DIR="$(dirname "$BINARY")"
       IDENTITY="${CODE_SIGN_IDENTITY:--}"
       echo "🔑 Re-signing MLKit at $FRAMEWORK_DIR with identity: $IDENTITY"
       codesign --force --sign "$IDENTITY" \
         --preserve-metadata=identifier,entitlements "$FRAMEWORK_DIR"
     BASH

     # Execute the patch script
     system('bash', '-c', patch_script)
   end
   ```

2. Run:

   ```bash
   cd ios
   pod install
   ```

3. Rebuild your app and verify no `nic.ir.md` occurrences remain:

   ```bash
   grep -ria "nic.ir.md" ./Pods
   ```

## 🤖 Android Configuration

The Android side is currently **untested**. Contributions and feedback are welcome! If you encounter any issues, please open an issue on GitHub.

---

