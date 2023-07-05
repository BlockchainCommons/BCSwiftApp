import SwiftUI

public struct ExportDataButton<Content>: View where Content: View {
    let content: Content
    let isSensitive: Bool
    let action: () -> Void
    
    @Environment(\.isEnabled)
    private var isEnabled: Bool
    
    public var body: some View {
        Button {
            action()
        } label: {
            content
                .font(Font.system(.body).bold())
                .foregroundColor((isEnabled && isSensitive) ? .yellowLightSafe : .accentColor)
        }
        .buttonStyle(.bordered)
    }
}

public extension ExportDataButton where Content == MenuLabel<Label<Text, AnyView>> {
    init(_ text: Text, icon: Image, isSensitive: Bool, action: @escaping () -> Void) {
        self.init(content: MenuLabel(text, icon: icon), isSensitive: isSensitive, action: action)
    }

    init(_ string: String, icon: Image, isSensitive: Bool, action: @escaping () -> Void) {
        self.init(Text(markdown: string), icon: icon, isSensitive: isSensitive, action: action)
    }
}
