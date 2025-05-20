import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pdf_compressor_ios_method_channel.dart';

abstract class PdfCompressorIosPlatform extends PlatformInterface {
  /// Constructs a PdfCompressorIosPlatform.
  PdfCompressorIosPlatform() : super(token: _token);

  static final Object _token = Object();

  static PdfCompressorIosPlatform _instance = MethodChannelPdfCompressorIos();

  /// The default instance of [PdfCompressorIosPlatform] to use.
  ///
  /// Defaults to [MethodChannelPdfCompressorIos].
  static PdfCompressorIosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PdfCompressorIosPlatform] when
  /// they register themselves.
  static set instance(PdfCompressorIosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
