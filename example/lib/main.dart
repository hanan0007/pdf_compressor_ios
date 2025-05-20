import 'package:flutter/material.dart';
import 'package:pdf_compressor_ios/pdf_compressor_ios.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Compressor iOS Demo',
      home: const CompressorPage(),
    );
  }
}

class CompressorPage extends StatefulWidget {
  const CompressorPage({super.key});

  @override
  State<CompressorPage> createState() => _CompressorPageState();
}

class _CompressorPageState extends State<CompressorPage> {
  double? originalSizeMB;
  double? compressedSizeMB;
  bool isLoading = false;

  Future<void> _pickAndCompressPDF() async {
    setState(() => isLoading = true);

    try {
      final compressed = await PdfCompressor.compress(
        filePath: "filePath",
        quality: PdfQuality.medium,
      );

      setState(() {
        originalSizeMB = compressed.originalSizeMB;
        compressedSizeMB = compressed.compressedSizeMB;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Compression failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Compressor iOS')),
      body: Center(
        child:
            isLoading
                ? const CircularProgressIndicator()
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickAndCompressPDF,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("Pick & Compress PDF"),
                    ),
                    const SizedBox(height: 20),
                    if (originalSizeMB != null && compressedSizeMB != null) ...[
                      Text(
                        "Original: ${originalSizeMB!.toStringAsFixed(2)} MB",
                      ),
                      Text(
                        "Compressed: ${compressedSizeMB!.toStringAsFixed(2)} MB",
                      ),
                    ],
                  ],
                ),
      ),
    );
  }
}
