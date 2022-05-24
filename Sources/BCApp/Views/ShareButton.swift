import SwiftUI

public struct ShareButton<Content>: View where Content: View {
    let content: Content
    let isSensitive: Bool
    let params: () -> ActivityParams
    @State private var activityParams: ActivityParams?

    public init(content: Content, isSensitive: Bool, params: @escaping () -> ActivityParams) {
        self.content = content
        self.isSensitive = isSensitive
        self.params = params
    }

    public var body: some View {
        ExportDataButton(content: content, isSensitive: isSensitive) {
            activityParams = params()
        }
        .background(ActivityView(params: $activityParams))
    }
}

public extension ShareButton where Content == MenuLabel<Label<Text, AnyView>> {
    init(_ text: Text, icon: Image, isSensitive: Bool, params: @autoclosure @escaping () -> ActivityParams) {
        self.init(content: MenuLabel(text, icon: icon), isSensitive: isSensitive, params: params)
    }

    init(_ string: String, icon: Image, isSensitive: Bool, params: @autoclosure @escaping () -> ActivityParams) {
        self.init(Text(string), icon: icon, isSensitive: isSensitive, params: params())
    }
}
