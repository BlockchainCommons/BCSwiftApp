import SwiftUI

public struct TransactionChat<Content>: View where Content: View {
    let response: Response
    let content: () -> Content
    
    public enum Response {
        case composing
        case error
        case none
    }
    
    public init(response: Response = .composing, @ViewBuilder content: @escaping () -> Content) {
        self.response = response
        self.content = content
    }
    
    public var body: some View {
        let radius = 30.0
        HStack {
            ChatBubble(direction: .leading, fill: Color.secondary.opacity(0.4), stroke: .secondary, lineWidth: 3, radius: radius) {
                content()
                    .padding(5)
                    .font(.title)
            }
            if response != .none {
                Spacer()
                Group {
                    if response == .error {
                        ChatBubble(direction: .trailing, fill: Color.red.opacity(0.4), stroke: .red, lineWidth: 3, radius: radius) {
                            Image.error
                                .foregroundColor(.red)
                                .padding([.leading, .trailing], 20)
                                .padding([.top, .bottom], 5)
                        }
                    } else {
                        ChatBubble(direction: .trailing, fill: Color.accentColor.opacity(0.4), stroke: .accentColor, lineWidth: 3, radius: radius) {
                            Image.ellipsis
                                .foregroundColor(.accentColor)
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
}

#if DEBUG

struct TransactionChat_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TransactionChat(response: .composing) {
                Text("Hello")
            }
            TransactionChat(response: .error) {
                Text("Hello")
            }
        }
        .padding()
        .darkMode()
    }
}

#endif
