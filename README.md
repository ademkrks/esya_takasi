# esya_takas

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Windows note

The repository currently lives in a folder with Turkish characters. Android
builds on Windows need to run from an ASCII path. Use `flutterw.bat` from the
project root instead of calling `flutter` directly:

```bat
flutterw.bat run -d emulator-5554
flutterw.bat build apk --debug
```

The wrapper creates a temporary ASCII drive mapping before invoking Flutter, so
the project can be built without moving the repository.
