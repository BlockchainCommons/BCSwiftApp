import SwiftUI

public struct EraseAllDataButton: View {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Label("Erase All Data", systemImage: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .font(Font.body.bold())
        }
        .formSectionStyle()
    }
}
