import SwiftUI

public struct ScanButton: View {
    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
            Image.scan
        }
        .accessibility(label: Text("Scan"))
    }
}
