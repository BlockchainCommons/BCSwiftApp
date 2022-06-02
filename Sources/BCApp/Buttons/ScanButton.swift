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
                .padding(10)
        }
        .font(.title)
        .accessibility(label: Text("Scan"))
    }
}
