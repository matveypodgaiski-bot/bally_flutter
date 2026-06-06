@echo off
echo Building APK...
cd bally_flutter
flutter build apk --release
echo APK ready!
echo Location: build\app\outputs\flutter-apk\app-release.apk
pause
