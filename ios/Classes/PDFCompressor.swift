import Foundation
import PDFKit
import UIKit

@objc class PDFCompressor: NSObject {

    @objc static func compressPDF(
        atPath filePath: String, quality: String, completion: @escaping ([String: Any]?) -> Void
    ) {
        guard let fileData = FileManager.default.contents(atPath: filePath),
            let pdfDocument = PDFDocument(data: fileData)
        else {
            completion(nil)
            return
        }

        // Convert original size to MB
        let originalSizeMB = Double(fileData.count) / (1024 * 1024)

        let finalDocument = PDFDocument()

        let compressionQuality: CGFloat = {
            switch quality.lowercased() {
            case "low": return 0.25
            case "medium": return 0.5
            case "high": return 0.75
            default: return 0.5
            }
        }()

        let maxDimension: CGFloat = 6000  // Safe max size to avoid memory issues

        for i in 0..<pdfDocument.pageCount {
            guard let page = pdfDocument.page(at: i) else {
                print("⚠️ Skipping page \(i): page nil")
                continue
            }

            let pageRect = page.bounds(for: .mediaBox)

            if pageRect.width <= 0 || pageRect.height <= 0 {
                print("⚠️ Skipping page \(i): invalid size \(pageRect)")
                continue
            }

            if pageRect.width > maxDimension || pageRect.height > maxDimension {
                print("⚠️ Skipping page \(i): too large \(pageRect)")
                continue
            }

            autoreleasepool {
                let renderer = UIGraphicsImageRenderer(size: pageRect.size)

                let img = renderer.image { ctx in
                    UIColor.white.set()
                    ctx.fill(CGRect(x: 0, y: 0, width: pageRect.width, height: pageRect.height))
                    ctx.cgContext.translateBy(
                        x: -pageRect.origin.x, y: pageRect.size.height - pageRect.origin.y)
                    ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                    page.draw(with: .mediaBox, to: ctx.cgContext)
                }

                guard let imageData = img.jpegData(compressionQuality: compressionQuality),
                    let resultImage = UIImage(data: imageData),
                    let pdfPage = PDFPage(image: resultImage)
                else {
                    print("⚠️ Skipping page \(i): image or PDF page creation failed")
                    return
                }

                finalDocument.insert(pdfPage, at: finalDocument.pageCount)
            }
        }

        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("compressed_" + (filePath as NSString).lastPathComponent)

        finalDocument.write(to: outputURL)

        let compressedSizeBytes = (try? Data(contentsOf: outputURL).count) ?? 0
        let compressedSizeMB = Double(compressedSizeBytes) / (1024 * 1024)

        completion([
            "originalSizeMB": originalSizeMB,
            "compressedSizeMB": compressedSizeMB,
            "compressedPath": outputURL.path,
        ])
    }
}
