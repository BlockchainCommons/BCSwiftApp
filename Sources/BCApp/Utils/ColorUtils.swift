import UIKit
import UIImageColors
import simd
import WolfBase

public func getMatchedColors(for image: UIImage, quality: UIImageColorsQuality = .high) -> MatchedImageColors? {
    guard let imageColors = image.getColors(quality: quality) else { return nil }
    return MatchedImageColors(
        background: ImageColorMatch(color: imageColors.background),
        primary: ImageColorMatch(color: imageColors.primary),
        secondary: ImageColorMatch(color: imageColors.secondary),
        detail: ImageColorMatch(color: imageColors.detail)
    )
}

public extension Colour {
    func distance(to other: Colour) -> Double {
        let v1 = SIMD3<Double>(red, green, blue)
        let v2 = SIMD3<Double>(other.red, other.green, other.blue)
        let d = v2 - v1
        return simd_length(d)
    }
}

public func closestNamedColor(to color: Colour) -> NamedColor {
    var bestNamedColor: NamedColor!
    var bestDistance: Double = .infinity
    NamedColor.colors.forEach { namedColor in
        let d = color.distance(to: namedColor.color)
        if d < bestDistance {
            bestNamedColor = namedColor
            bestDistance = d
        }
    }
    return bestNamedColor
}

public struct ImageColorMatch {
    public let color: UIColor
    public let namedColor: NamedColor

    public init(color: UIColor) {
        self.color = color
        namedColor = closestNamedColor(to: Colour(color))
    }
}

public struct MatchedImageColors {
    public let background: ImageColorMatch
    public let primary: ImageColorMatch
    public let secondary: ImageColorMatch
    public let detail: ImageColorMatch
}

public struct NamedColor: Decodable {
    public let name: String
    public let color: Colour

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let colorString = try container.decode(String.self)
        color = try Colour(string: colorString)
        name = try container.decode(String.self)
    }

    public static let colors: [NamedColor] = {
        let url = Bundle.module.url(forResource: "NamedColors", withExtension: "json")!
        let data = try! Data.init(contentsOf: url)
        return try! JSONDecoder().decode([NamedColor].self, from: data)
    }()
}
