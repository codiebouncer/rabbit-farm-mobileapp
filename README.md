# Rabbit Farm Mobile App

Flutter client for Abowoso Rabbit Farm.

## API environment

Debug builds default to the local iOS Simulator API at
`http://127.0.0.1:5139/api`. Release builds require an explicit API address.

```bash
# iOS simulator or desktop
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:5139/api

# Android emulator
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5139/api
```

Use an HTTPS URL for staging and production builds. VS Code launch profiles for
both local emulator variants are included in `.vscode/launch.json`.

## Verification

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```
