#!/bin/bash

# Configuration
PROJECT_NAME="AnyVideoToMp4Converter"
CONVERTER_SCRIPT="converter.py"
ICON_NAME="app.icns" # Optional, if you have an icon

echo "🚀 Building $PROJECT_NAME..."

# Ensure we are in the correct directory
cd "$(dirname "$0")"

# Download and combine FFmpeg if missing
if [ ! -f "bin/ffmpeg" ]; then
    echo "⬇️ Downloading FFmpeg binaries (Universal)..."
    mkdir -p bin && cd bin
    curl -L https://evermeet.cx/ffmpeg/ffmpeg-8.0.1.zip -o ffmpeg-intel.zip
    curl -L https://www.osxexperts.net/ffmpeg80arm.zip -o ffmpeg-arm.zip
    unzip -o ffmpeg-intel.zip && mv ffmpeg ffmpeg-intel
    unzip -o ffmpeg-arm.zip && mv ffmpeg ffmpeg-arm
    rm -f *.zip LICENSE README.txt
    lipo -create ffmpeg-intel ffmpeg-arm -output ffmpeg
    rm -f ffmpeg-intel ffmpeg-arm
    chmod +x ffmpeg
    cd ..
    echo "✅ Universal FFmpeg ready."
fi

# Configuration
PROJECT_NAME="AnyVideoToMp4Converter"
CONVERTER_SCRIPT="converter.py"

echo "🚀 Building $PROJECT_NAME (WebUI version)..."

# Ensure we are in the correct directory
cd "$(dirname "$0")"

# Remove old build artifacts
rm -rf build dist AnyVideoToMp4Converter.spec

# Run PyInstaller
# --windowed: Do not open a console window
# --add-data: Include the UI folder and bin folder (with ffmpeg)
# --onefile: Bundle into a single executable (inside the app)
# --target-arch: Build for both Intel and Apple Silicon
python3 -m PyInstaller \
    --windowed \
    --onefile \
    --add-data "ui:ui" \
    --add-data "bin:bin" \
    --target-arch universal2 \
    --name "$PROJECT_NAME" \
    --clean \
    "$CONVERTER_SCRIPT"

if [ $? -eq 0 ]; then
    echo "✅ App build successful!"
    echo "📂 The app is located in: $(pwd)/dist/$PROJECT_NAME.app"
    
    echo "📀 Creating DMG Installer..."
    
    # Ensure dist exists
    mkdir -p dist
    
    # Remove old DMG if exists
    rm -f "dist/$PROJECT_NAME.dmg"
    
    # Create DMG
    # --volname: Name of the mounted volume
    # --window-pos / --window-size: UI placement
    # --icon-size: Icon size
    # --icon: Placement of App and Applications link
    # --app-drop-link: Path to Applications link
    create-dmg \
        --volname "$PROJECT_NAME Installer" \
        --window-pos 200 120 \
        --window-size 500 300 \
        --icon-size 100 \
        --icon "$PROJECT_NAME.app" 125 125 \
        --hide-extension "$PROJECT_NAME.app" \
        --app-drop-link 375 125 \
        "dist/$PROJECT_NAME.dmg" \
        "dist/$PROJECT_NAME.app"

    if [ $? -eq 0 ]; then
        echo "✅ DMG creation successful!"
        echo "📂 The installer is located in: $(pwd)/dist/$PROJECT_NAME.dmg"
        
        # Remove the app bundle as requested by user (keeping only DMG)
        echo "🧹 Cleaning up app bundle..."
        rm -rf "dist/$PROJECT_NAME.app"
    else
        echo "❌ DMG creation failed."
        exit 1
    fi
else
    echo "❌ App build failed."
    exit 1
fi
