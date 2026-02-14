#!/usr/bin/env bash
# Fix "resource fork, Finder information, or similar detritus not allowed" when
# building iOS simulator. Run this before: flutter build ios --simulator --no-codesign
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
FLUTTER_ROOT="${FLUTTER_ROOT:-$(which flutter | xargs dirname | xargs dirname)}"

echo "Clearing extended attributes..."
xattr -cr "$PROJECT_DIR" 2>/dev/null || true
xattr -cr "$FLUTTER_ROOT/bin/cache/artifacts/engine/ios" 2>/dev/null || true
xattr -cr "$FLUTTER_ROOT/bin/cache/artifacts/engine/ios-release" 2>/dev/null || true
# If a previous build failed, clear the framework in build dir so next build gets a fresh copy
if [ -d "$PROJECT_DIR/build/ios" ]; then
  xattr -cr "$PROJECT_DIR/build/ios" 2>/dev/null || true
fi
echo "Done. Run: flutter build ios --simulator --no-codesign"
