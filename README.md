# 📄 pdf_compressor_ios

A lightweight Flutter plugin that compresses PDF files on **iOS devices** using native Swift and PDFKit rendering. It efficiently reduces file size by rasterizing pages and rebuilding the PDF with JPEG-compressed images.

> ✅ **iOS Only** – This plugin supports only iOS at the moment.

---

## ✨ Features

- Compress any PDF file using native iOS capabilities
- Choose from 3 compression levels: `low`, `medium`, `high`
- Returns:
  - Original size in MB
  - Compressed size in MB
  - Compressed PDF file path
- Works seamlessly with `file_picker` and `share_plus`

---

## 📱 Platform Support

| Platform | Support       |
|----------|----------------|
| iOS      | ✅ Supported   |
| Android  | ❌ Not yet supported |

---

## 🚀 Getting Started

### 1. Install

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  pdf_compressor_ios: ^0.0.1
