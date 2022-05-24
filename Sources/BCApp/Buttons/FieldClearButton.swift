import SwiftUI

public struct ClearButton: View {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Image.clearField
                .foregroundColor(.secondary)
        }
    }
}
