import 'dart:io';

import 'package:flutter/services.dart';

class PdfCompressor {
  static const MethodChannel _channel = MethodChannel('pdf_compressor');

  static Future<PdfCompressionResult> compress({
    required String filePath,
    PdfQuality quality = PdfQuality.medium,
  }) async {
    final result = await _channel.invokeMethod('compressPDF', {
      'filePath': filePath,
      'quality': _mapQuality(quality),
    });

    return PdfCompressionResult(
      originalSizeMB: (result['originalSizeMB'] as num).toDouble(),
      compressedSizeMB: (result['compressedSizeMB'] as num).toDouble(),
      compressedFile: File(result['compressedPath']),
    );
  }

  static String _mapQuality(PdfQuality quality) {
    switch (quality) {
      case PdfQuality.low:
        return 'low';
      case PdfQuality.medium:
        return 'medium';
      case PdfQuality.high:
        return 'high';
    }
  }
}

/// Enum for compression quality
enum PdfQuality { low, medium, high }

/// Model to hold the compression result
class PdfCompressionResult {
  final double originalSizeMB;
  final double compressedSizeMB;
  final File compressedFile;

  PdfCompressionResult({
    required this.originalSizeMB,
    required this.compressedSizeMB,
    required this.compressedFile,
  });
}
