import SwiftUI

public struct Rebus<Content>: View where Content: View {
    let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        HStack {
            content()
        }
        .font(.title)
        .lineLimit(1)
        .minimumScaleFactor(0.5)
    }
}
