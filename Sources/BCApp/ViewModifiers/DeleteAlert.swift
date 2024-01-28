import SwiftUI

struct DeleteAlert: ViewModifier {
    let title: String
    let message: String
    let actionName: String
    let action: () -> Void
    @Binding var isPresented: Bool

    init(isPresented: Binding<Bool>, title: String, message: String, actionName: String, action: @escaping () -> Void) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.actionName = actionName
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isPresented) {
                Button(role: .destructive) {
                    Haptic.success()
                    action()
                } label: {
                    Text(actionName)
                }
            } message: {
                Text(markdown: message)
            }
            .onChange(of: isPresented) { _, newValue in
                if newValue {
                    Haptic.warning()
                }
            }
    }
}

public extension View {
    func deleteAlert(_ isPresented: Binding<Bool>, title: String, message: String, actionName: String = "Delete", action: @escaping () -> Void) -> some View {
        modifier(DeleteAlert(isPresented: isPresented, title: title, message: message, actionName: actionName, action: action))
    }
}
