import Flutter
import UIKit

public class SwiftPdfCompressorPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "pdf_compressor", binaryMessenger: registrar.messenger())
    let instance = SwiftPdfCompressorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "compressPDF" {
      guard let args = call.arguments as? [String: Any],
        let path = args["filePath"] as? String,
        let quality = args["quality"] as? String
      else {
        result(FlutterError(code: "BAD_ARGS", message: "Missing filePath or quality", details: nil))
        return
      }

      PDFCompressor.compressPDF(atPath: path, quality: quality) { response in
        if let response = response {
          result(response)
        } else {
          result(
            FlutterError(code: "COMPRESSION_FAILED", message: "Compression failed", details: nil))
        }
      }
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
}
