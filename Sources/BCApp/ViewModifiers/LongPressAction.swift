import SwiftUI

struct LongPressAction: ViewModifier {
    let action: () -> Void
    @State var isPressing: Bool = false
    
    func body(content: Content) -> some View {
        content
            .onTapGesture { }
            .onLongPressGesture(minimumDuration: 0.8, pressing: { isPressing in
                withAnimation(.easeOut(duration: isPressing ? 0.8 : 0.2)) {
                    self.isPressing = isPressing
                }
            }, perform: {
                Haptic.copy()
                action()
            })
            .scaleEffect(isPressing ? 1.1 : 1.0)
    }
}

public extension View {
    func longPressAction(action: @escaping () -> Void) -> some View {
        modifier(LongPressAction(action: action))
    }
}

struct ConditionalLongPressAction: ViewModifier {
    let actionEnabled: Bool
    let action: () -> Void

    func body(content: Content) -> some View {
        if actionEnabled {
            content
                .longPressAction(action: action)
        } else {
            content
        }
    }
}

public extension View {
    func conditionalLongPressAction(actionEnabled: Bool, action: @escaping () -> Void) -> some View {
        modifier(ConditionalLongPressAction(actionEnabled: actionEnabled, action: action))
    }
}
