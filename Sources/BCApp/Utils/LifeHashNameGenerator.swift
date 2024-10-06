import Foundation
import LifeHash
import WolfLorem
import BCFoundation
import Observation

@MainActor @Observable
public final class LifeHashNameGenerator {
    public var suggestedName: String?
    private var colorName: String = "none"
    private let lifeHashState: LifeHashState?

    public init(lifeHashState: LifeHashState?) {
        self.lifeHashState = lifeHashState
        
        withObservationTracking {
            guard let image = lifeHashState?.osImage else {
                return
            }

            Task {
                let name = update(image: image)
                Task { @MainActor in
                    self.suggestedName = name
                }
            }
        } onChange: {
            Task { @MainActor in
                guard let image = lifeHashState?.osImage else {
                    return
                }
                Task {
                    let name = self.update(image: image)
                    Task { @MainActor in
                        self.suggestedName = name
                    }
                }
            }
        }


//        lifeHashState.osImage
//            .receive(on: DispatchQueue.global())
//            .map { uiImage in
//                guard let uiImage = uiImage else { return "Untitled" }
//                return self.update(image: uiImage)
//            }
//            .receive(on: DispatchQueue.main)
//            .assign(to: suggestedName)
        
        if let image = lifeHashState?.osImage {
            suggestedName = update(image: image)
        }
    }
    
//    private func handleUpdate() {
//        guard let image = lifeHashState.osImage else {
//            return
//        }
//
//        Task {
//            let name = update(image: image)
//            Task { @MainActor in
//                self.suggestedName = name
//            }
//        }
//    }
    
    public func update(image: OSImage) -> String {
        if let matchedColors = getMatchedColors(for: image, quality: .highest) {
            self.colorName = matchedColors.background.namedColor.name
        } else {
            self.colorName = NamedColor.colors.randomElement()!.name
        }
        return self.next()
    }

    public func next() -> String {
        let words = Lorem.bytewords(2)
        return [colorName, words].joined(separator: " ").capitalized
    }
    
    public static func generate(from item: Fingerprintable) -> String {
        let lifehashState = LifeHashState(item.fingerprint, version: .version2, generateAsync: false)
        let generator = LifeHashNameGenerator(lifeHashState: lifehashState)
        return generator.next()
    }
}

public extension Lorem {
    static func bytewords(_ count: Int) -> String {
        (0..<count)
            .map( { _ in Bytewords.allWords.randomElement()! } )
            .joined(separator: " ")
    }
}
