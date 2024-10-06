import Foundation
import UIKit
import os

public protocol ImageLoader: Sendable {
    @Sendable func loadImage() async throws -> UIImage;
}

public func extractQRCodes(from imageLoaders: [ImageLoader]) async -> [String] {
    await withTaskGroup(of: [String].self) { group -> [String] in
        imageLoaders.forEach { loader in
            group.addTask {
                guard
                    let image = try? await loader.loadImage(),
                    let result = try? await image.detectQRCodes()
                else {
                    return []
                }
                return result
            }
        }
        var result: [String] = []
        for await messages in group {
            result.append(contentsOf: messages)
        }
        return result
    }
}
