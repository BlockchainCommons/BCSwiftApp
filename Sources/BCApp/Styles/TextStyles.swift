import SwiftUI

public extension Text {
    func monospaced(weight: Font.Weight = .regular) -> Text {
        font(.system(.body, design: .monospaced).weight(weight))
    }
    
    func monospaced(size: CGFloat, weight: Font.Weight = .regular) -> Text {
        font(.system(size: size, weight: weight, design: .monospaced))
    }
    
    func errorStyle() -> Text {
        self
            .font(.footnote)
            .foregroundColor(.red)
    }
}
