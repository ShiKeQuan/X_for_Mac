#!/bin/bash
set -e

APP_NAME=X_for_mac
APP_BUNDLE="$PWD/dist/X_for_mac.app"
BIN="$PWD/.build/release/X_for_mac"

echo "Building..."
swift build -c release

echo "Packaging..."
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS" "$APP_BUNDLE/Contents/Resources"

# Copy icon
if [ -f "Resources/AppIcon.icns" ]; then
    cp Resources/AppIcon.icns "$APP_BUNDLE/Contents/Resources/"
    echo "Icon copied"
fi

cat > "$APP_BUNDLE/Contents/Info.plist" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>CFBundleName</key><string>X_for_mac</string>
  <key>CFBundleDisplayName</key><string>X for Mac</string>
  <key>CFBundleIdentifier</key><string>com.example.xformac</string>
  <key>CFBundleExecutable</key><string>X_for_mac</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>0.2.0</string>
  <key>CFBundleVersion</key><string>2</string>
  <key>LSMinimumSystemVersion</key><string>14.0</string>
  <key>NSPrincipalClass</key><string>NSApplication</string>
  <key>NSHighResolutionCapable</key><true/>
  <key>CFBundleIconFile</key><string>AppIcon</string>
</dict></plist>
EOF

cp "$BIN" "$APP_BUNDLE/Contents/MacOS/$APP_NAME"

echo "Signing..."
codesign --force --deep --sign - "$APP_BUNDLE"

echo "Done! Opening app..."
open "$APP_BUNDLE"
