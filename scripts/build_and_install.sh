#!/usr/bin/env bash
# Build release APK and iOS, then install on Android emulator and run on iOS simulator.
# Prerequisites: Android emulator and iOS simulator running (flutter devices).

set -e
cd "$(dirname "$0")/.."

echo "=== Building release APK ==="
flutter build apk --release

APK="build/app/outputs/flutter-apk/app-release.apk"
if [[ -f "$APK" ]]; then
  echo "=== Installing on Android emulator ==="
  adb devices
  adb install -r "$APK"
  echo "Android: Installed. Open 'Expense Tracker' on the emulator."
else
  echo "APK not found at $APK"
  exit 1
fi

echo "=== Building iOS (release, for device) ==="
flutter build ios --release

echo "=== To run on iOS simulator ==="
echo "  flutter run -d <ios-simulator-id>"
echo "  (Release mode is not supported on simulator; this builds and runs in debug.)"
echo ""
echo "Done. Android release APK installed on emulator. iOS release built; run above for simulator."
