import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pdf_compressor_ios_platform_interface.dart';

/// An implementation of [PdfCompressorIosPlatform] that uses method channels.
class MethodChannelPdfCompressorIos extends PdfCompressorIosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pdf_compressor_ios');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
