import SwiftUI

struct FormSectionStyle: ViewModifier {
    let isVisible: Bool

    func body(content: Content) -> some View {
        content
            .padding(isVisible ? 10 : 0)
            .background(isVisible ? Color(UIColor.formGroupBackground) : Color.clear)
            .cornerRadius(isVisible ? 10 : 0)
    }
}

public extension View {
    func formSectionStyle(isVisible: Bool = true) -> some View {
        modifier(FormSectionStyle(isVisible: isVisible))
    }
}
