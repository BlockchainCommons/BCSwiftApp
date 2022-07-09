import SwiftUI

public struct TransactionChat<Content>: View where Content: View {
    let cannotRespond: Bool
    let content: () -> Content
    
    public init(cannotRespond: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.cannotRespond = cannotRespond
        self.content = content
    }
    
    public var body: some View {
        let radius: Binding<Double> = .constant(30)
        HStack {
            ChatBubble(direction: .leading, fill: Color.secondary.opacity(0.4), stroke: .secondary, lineWidth: 3, radius: radius) {
                content()
                    .padding(5)
                    .font(.title)
            }
            Spacer()
            Group {
                if cannotRespond {
                    ChatBubble(direction: .trailing, fill: Color.red.opacity(0.4), stroke: .red, lineWidth: 3, radius: radius) {
                        Image.error
                            .padding([.leading, .trailing], 20)
                            .padding([.top, .bottom], 5)
                    }
                } else {
                    ChatBubble(direction: .trailing, fill: Color.accentColor.opacity(0.4), stroke: .accentColor, lineWidth: 3, radius: radius) {
                        Image.ellipsis
                            .padding([.leading, .trailing], 20)
                            .padding([.top, .bottom], 15)
                    }
                }
            }
            .font(.title)
            .alignmentGuide(VerticalAlignment.center, computeValue: { _ in 0 })
        }
    }
}

#if DEBUG

struct TransactionChat_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TransactionChat(cannotRespond: false) {
                Text("Hello")
            }
            TransactionChat(cannotRespond: true) {
                Text("Hello")
            }
        }
        .padding()
        .darkMode()
    }
}

#endif
