import SwiftUI

public struct ConditionalGroupBox<Label, Content>: View where Label : View, Content : View {
    let isVisible: Bool
    let label: () -> Label
    let content: () -> Content

    public init(isVisible: Bool = true, @ViewBuilder label: @escaping () -> Label, @ViewBuilder content: @escaping () -> Content) {
        self.isVisible = isVisible
        self.label = label
        self.content = content
    }

    public var body: some View {
        if isVisible {
            return GroupBox(label: label(), content: content).eraseToAnyView()
        } else {
            return content().eraseToAnyView()
        }
    }
}
