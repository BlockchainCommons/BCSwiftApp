import SwiftUI

public struct TransactionChat<Content>: View where Content: View {
    let cannotRespond: Bool
    let content: () -> Content
    
    public init(cannotRespond: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.cannotRespond = cannotRespond
        self.content = content
    }
    
    public var body: some View {
        HStack {
            VStack {
                ChatBubble(direction: .leading, background: Color.secondary.opacity(0.4)) {
                    content()
                        .padding(10)
                        .font(.title)
                }
//                Spacer()
//                    .frame(height: 10)
            }
            Spacer()
            VStack {
//                Spacer()
//                    .frame(height: 10)
                if cannotRespond {
                    ChatBubble(direction: .trailing, background: Color.red.opacity(0.4)) {
                        Image.error
                            .padding([.leading, .trailing], 20)
                            .padding([.top, .bottom], 10)
                            .font(.title)
                    }
                } else {
                    ChatBubble(direction: .trailing, background: Color.accentColor.opacity(0.2)) {
                        Image.ellipsis
                            .padding(20)
                            .font(.title)
                    }
                }
            }
        }
    }
}
