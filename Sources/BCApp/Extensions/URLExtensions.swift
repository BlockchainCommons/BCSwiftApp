import Foundation
import UIKit
import UniformTypeIdentifiers

@MainActor
public extension UTType {
    static var psbt = UTType("com.blockchaincommons.psbt")!
}

@MainActor
public extension URL {
    var isPSBT: Bool {
        (try? resourceValues(forKeys: [.contentTypeKey]).contentType?.conforms(to: .psbt)) ?? false
    }
}

extension URL: ImageLoader {
    public var isImage: Bool {
        (try? resourceValues(forKeys: [.contentTypeKey]).contentType?.conforms(to: .image)) ?? false
    }
    
    public func loadImage() async throws -> UIImage {
        let data = try Data(contentsOf: self)
        guard let image = UIImage(data: data) else {
            throw GeneralError("Could not read image for: \(self)")
        }
        return image
    }
}
