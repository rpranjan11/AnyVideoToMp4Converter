# AnyVideoToMp4Converter

A modern, fast, and "smart" video converter for macOS that intelligently transcodes videos to MP4 format. 

[![Releases](https://img.shields.io/github/v/release/rpranjan11/AnyVideoToMp4Converter?style=flat-square)](https://github.com/rpranjan11/AnyVideoToMp4Converter/releases)

## 🚀 Key Features

- **Apple Silicon Native**: Built exclusively for **M1, M2, M3, and M4** chips (arm64) for maximum performance.
- **GPU Optimized**: Uses the **Hardware Media Engines** (VideoToolbox) for blazing fast transcoding.
- **Smart Transcoding**: Copies H.264/AAC streams whenever possible for 3-10 second conversions.
- **High Quality**: Uses robust hardware encoding settings equivalent to high-quality software presets.
- **Self-Contained**: Bundles its own optimized FFmpeg binary; no external dependencies.
- **Modern UI**: Sleek dark-mode interface with glassmorphism effects.
- **Batch Processing**: Convert multiple files in sequence with a single click.

## 💾 Installation

1. Go to the [Releases](https://github.com/rpranjan11/AnyVideoToMp4Converter/releases) page.
2. Download either the **AnyVideoToMp4Converter.dmg** (Recommended) or the **AnyVideoToMp4Converter.zip**.
3. **If using DMG**: Open it and drag the app to your **Applications** folder.
4. **If using ZIP**: Extract it and move the app to your **Applications** folder.

### 🛡️ How to Bypass Security Warnings ("Not Opened" / "Malware")
Since the app is not signed with an Apple Developer ID, macOS will block it by default. Follow these steps:

1. **Attempt to launch** the app once. When the warning appears, click **Done**.
2. Open **System Settings** -> **Privacy & Security**.
3. Scroll down to the **Security** section.
4. You will see a notice saying: *"AnyVideoToMp4Converter was blocked..."*.
5. Click **Open Anyway**, enter your password, and confirm **Open**.
6. **Alternative**: If you are comfortable with the Terminal, run:
   `xattr -cr /Applications/AnyVideoToMp4Converter.app`

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
