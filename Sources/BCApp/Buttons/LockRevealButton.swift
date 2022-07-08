import SwiftUI

public struct LockRevealButton<RevealedContent, HiddenContent>: View where RevealedContent: View, HiddenContent: View {
    let revealed: () -> RevealedContent
    let hidden: () -> HiddenContent
    @Binding var isRevealed: Bool
    let isSensitive: Bool
    let isChatBubble: Bool
    @StateObject var authentication: Authentication = Authentication()

    public init(isRevealed: Binding<Bool>, isSensitive: Bool, isChatBubble: Bool, @ViewBuilder revealed: @escaping () -> RevealedContent, @ViewBuilder hidden: @escaping () -> HiddenContent) {
        self._isRevealed = isRevealed
        self.isSensitive = isSensitive
        self.isChatBubble = isChatBubble
        self.revealed = revealed
        self.hidden = hidden
    }

    public var body: some View {
        framedContent
        .onChange(of: isRevealed) {
            if !$0 {
                authentication.isUnlocked = false
            }
        }
        .onReceive(authentication.$isUnlocked) { isUnlocked in
            guard isRevealed != isUnlocked else { return }
            withAnimation {
                isRevealed = isUnlocked
            }
            if isRevealed {
                Feedback.unlock.play()
            } else {
                Feedback.lock.play()
            }
        }
    }
    
    @ViewBuilder
    var framedContent: some View {
        if isChatBubble {
            ChatBubble(direction: .trailing, background: Color.accentColor.opacity(0.2)) {
                content
            }
        } else {
            content
                .background(Color(UIColor.formGroupBackground))
                .cornerRadius(10)
        }
    }
    
    var content: some View {
        HStack {
            Button {
                if authentication.isUnlocked {
                    authentication.lock()
                } else {
                    authentication.attemptUnlock(reason: "Required to view or export the data.")
                }
            } label: {
                HStack(alignment: .firstTextBaseline) {
                    Image.toggleUnlocked(isRevealed: isRevealed)
                        .accentColor(isSensitive ? .yellowLightSafe : .appAccentColor)
                        .accessibility(label: Text(isRevealed ? "Lock" : "Unlock"))
                    if !isRevealed {
                        hidden()
                    }
                }
                .padding(10)
            }
            if isRevealed {
                revealed()
            }
        }
        .padding(isRevealed ? 20 : 10)
    }
}


//#if DEBUG
//
//import WolfLorem
//
//struct LockRevealButton_Previews: PreviewProvider {
//    struct ButtonPreview: View {
//        @State var isRevealed: Bool = false
//        var body: some View {
//            LockRevealButton(isRevealed: $isRevealed) {
//                HStack {
//                    Text(Lorem.sentence())
//                        .foregroundColor(Color.primary)
//                    Button {
//                    } label: {
//                        Label("Foo", systemImage: "printer")
//                    }
//                    .padding(5)
//                }
//            } hidden: {
//                Text("Hidden")
//                    .foregroundColor(Color.secondary)
//            }
//        }
//    }
//    static var previews: some View {
//        ButtonPreview()
//        .formSectionStyle()
//        .darkMode()
//    }
//}
//
//#endif
