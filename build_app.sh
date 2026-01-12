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
    echo "✅ Build successful!"
    echo "📂 The app is located in: $(pwd)/dist/$PROJECT_NAME.app"
else
    echo "❌ Build failed."
    exit 1
fi
