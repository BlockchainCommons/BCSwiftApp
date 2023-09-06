import SwiftUI

public struct ClearButton: View {
    let title: String?
    let message: String?
    let actionName: String?
    let action: () -> Void
    @State var isPresented: Bool = false

    public init(action: @escaping () -> Void) {
        self.title = nil
        self.message = nil
        self.actionName = nil
        self.action = action
    }
    
    public init(title: String, message: String, actionName: String = "Clear", action: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.action = action
        self.actionName = actionName
    }
    
    public var body: some View {
        Button(action: performAction) {
            Image.clearField
                .foregroundColor(.secondary)
        }
        .deleteAlert($isPresented, title: title ?? "", message: message ?? "", actionName: actionName ?? "", action: action)
    }
    
    func performAction() {
        if title != nil {
            isPresented = true
        } else {
            action()
        }
    }
}
