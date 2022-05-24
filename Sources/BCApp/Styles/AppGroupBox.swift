import SwiftUI

public struct AppGroupBox<Label, Content>: View where Label: View, Content: View {
    let content: Content
    let label: Label
    
    public init(@ViewBuilder label: () -> Label, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.label = label()
    }
    
    public init(label: Label, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.label = label
    }

    public var body: some View {
        GroupBox(content: {content}, label: {label})
            .formGroupBoxStyle()
    }
}

public extension AppGroupBox where Label == EmptyView {
    init(@ViewBuilder content: () -> Content) {
        self.init(label: {EmptyView()}, content: content)
    }
}

public extension AppGroupBox where Label == Text {
    init<S>(_ title: S, @ViewBuilder content: () -> Content) where S : StringProtocol {
        self.init(label: { Text(title) }, content: content)
    }

    init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.init(label: { Text(titleKey) }, content: content)
    }
}
