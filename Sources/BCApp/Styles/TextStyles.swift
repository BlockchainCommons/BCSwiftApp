import SwiftUI

public extension Text {
    func appMonospaced(weight: Font.Weight = .regular) -> Text {
        font(.system(.body, design: .monospaced).weight(weight))
    }
    
    func appMonospaced(size: CGFloat, weight: Font.Weight = .regular) -> Text {
        font(.system(size: size, weight: weight, design: .monospaced))
    }

    func futureMonospaced() -> some View {
        if #available(iOS 16.0, *) {
            return monospaced()
        } else {
            return appMonospaced()
        }
    }

    func errorStyle() -> Text {
        self
            .font(.footnote)
            .foregroundColor(.red)
    }
}
