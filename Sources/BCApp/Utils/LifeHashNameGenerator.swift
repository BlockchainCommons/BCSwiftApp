import Foundation
import LifeHash
import WolfLorem
import BCFoundation

public final class LifeHashNameGenerator: ObservableObject {
    @Published public var suggestedName: String?
    private var colorName: String = "none"

    public init(lifeHashState: LifeHashState?) {
        guard let lifeHashState = lifeHashState else { return }

        lifeHashState.$osImage
            .receive(on: DispatchQueue.global())
            .map { uiImage in
                guard let uiImage = uiImage else { return "Untitled" }
                return self.update(image: uiImage)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$suggestedName)
        
        if let image = lifeHashState.osImage {
            suggestedName = update(image: image)
        }
    }
    
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
