import Foundation
import UIKit
import UniformTypeIdentifiers

public extension UTType {
    static var psbt = UTType("com.blockchaincommons.psbt")!
}

public extension URL {
    var isPSBT: Bool {
        (try? resourceValues(forKeys: [.contentTypeKey]).contentType?.conforms(to: .psbt)) ?? false
    }
}

extension URL: ImageLoader {
    public var isImage: Bool {
        (try? resourceValues(forKeys: [.contentTypeKey]).contentType?.conforms(to: .image)) ?? false
    }
    
    public func loadImage(completion: @escaping (Result<UIImage, Error>) -> Void) {
        DispatchQueue.global().async {
            do {
                let image = try loadImageSync()
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    // Don't call from main thread
    public func loadImageSync() throws -> UIImage {
        _ = self.startAccessingSecurityScopedResource()
        defer {
            self.stopAccessingSecurityScopedResource()
        }
        guard let data = try? Data(contentsOf: self) else {
            throw GeneralError("Could not read data for: \(self)")
        }
        guard let image = UIImage(data: data) else {
            throw GeneralError("Could not form image from data at: \(self)")
        }
        return image
    }
}
