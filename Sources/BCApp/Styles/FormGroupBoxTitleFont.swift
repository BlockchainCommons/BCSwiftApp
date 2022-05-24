import SwiftUI

struct FormGroupBoxTitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content.font(Font.system(.headline).smallCaps())
    }
}

public extension View {
    func formGroupBoxTitleFont() -> some View {
        modifier(FormGroupBoxTitleFont())
    }
}
