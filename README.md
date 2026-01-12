# AnyVideoToMp4Converter

A modern, fast, and "smart" video converter for macOS that intelligently transcodes videos to MP4 format. 

[![Releases](https://img.shields.io/github/v/release/rpranjan11/AnyVideoToMp4Converter?style=flat-square)](https://github.com/rpranjan11/AnyVideoToMp4Converter/releases)

## 🚀 Key Features

- **Smart Transcoding**: Copies H.264 video and AAC audio streams without re-encoding whenever possible (lossless!).
- **High-Quality Conversion**: Uses `libx264` (CRF 18) for superior quality when transcoding is required.
- **Universal Binary**: Runs natively on both Apple Silicon (M1/M2/M3) and Intel Macs.
- **Self-Contained**: Bundles its own FFmpeg binary; no external dependencies required.
- **Modern UI**: Sleek dark-mode interface with glassmorphism effects.
- **Batch Processing**: Convert multiple files in sequence with a single click.
- **Real-time Status**: Track the progress and status of each conversion.

## 💾 Installation

1. Go to the [Releases](https://github.com/rpranjan11/AnyVideoToMp4Converter/releases) page.
2. Download the latest `AnyVideoToMp4Converter.dmg`.
3. Open the DMG and drag the application to your **Applications** folder.

### 🛡️ How to Bypass Security Warnings ("Not Opened" / "Malware")
Since the app is not signed with an Apple Developer ID, macOS will block it by default. Follow these steps to open it:

1. **Right-click** (or Control-click) the **AnyVideoToMp4Converter** icon in your **Applications** folder.
2. Select **Open** from the menu.
3. A dialog will appear saying "Apple could not verify...". Click the **Open** button that now appears in the prompt.
4. You only need to do this once. Future opens will work normally.

## 🛠 Usage

- **Add Files**: Use the "Add Files" button to select one or multiple videos.
- **Start**: Click "Start Conversion" to begin the batch process.
- **Stop**: Use the "Stop" button at any time to pause the queue.
- **Locate**: Once a file is finished, click "Locate" to open its folder in Finder.

## 📜 Technical Details

- **Backend**: Python 3.9
- **Frontend**: HTML/CSS/JS via `pywebview`
- **Engine**: FFmpeg (Universal2 Static Build)
- **Bundler**: PyInstaller

---
Developed by **Ranjan Ram Pratap**
Explore more projects at [theranjana.com](https://theranjana.com)
