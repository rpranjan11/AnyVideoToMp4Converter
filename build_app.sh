#!/bin/bash

# Configuration
PROJECT_NAME="AnyVideoToMp4Converter"
CONVERTER_SCRIPT="converter.py"
ICON_NAME="app.icns" # Optional, if you have an icon

echo "🚀 Building $PROJECT_NAME..."

# Ensure we are in the correct directory
cd "$(dirname "$0")"

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
# --add-data: Include the UI folder
# --onefile: Bundle into a single executable (inside the app)
python3 -m PyInstaller \
    --windowed \
    --onefile \
    --add-data "ui:ui" \
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
