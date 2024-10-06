import UIKit

public extension UIImage {
    func detectQRCodes() async throws -> [String] {
        guard let image = CIImage(image: self) else {
            throw GeneralError("Could not convert image to CIImage.")
        }
        let options = [
            CIDetectorAccuracy: CIDetectorAccuracyHigh,
            CIDetectorImageOrientation: image.properties[kCGImagePropertyOrientation as String] ?? 1
        ]
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options) else {
            throw GeneralError("Could not create QR code detector.")
        }
        let messages = detector.features(in: image, options: options).compactMap { feature in
            (feature as? CIQRCodeFeature)?.messageString
        }
        return messages;
    }
}
