# K-Viet Talk

K-Viet Talk is a local-first Flutter app for Vietnamese learners studying Korean.

## Android release signing

Release signing uses `android/key.properties` when that file exists and has all required values.
Do not commit the keystore or `key.properties`.

1. Place the release keystore at `android/keystore/kviettalk-release.jks`.
2. Copy `android/key.properties.example` to `android/key.properties`.
3. Fill in the real password and alias values locally.

Example `android/key.properties` format:

```properties
storeFile=keystore/kviettalk-release.jks
storePassword=your-keystore-password
keyAlias=your-key-alias
keyPassword=your-key-password
```

Back up the keystore and passwords securely. If the keystore is lost, future app updates with the
same signing key may not be possible.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
