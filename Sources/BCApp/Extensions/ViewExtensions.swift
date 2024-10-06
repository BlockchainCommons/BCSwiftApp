import SwiftUI

@MainActor
extension View {
    public func encircle(color: Color) -> some View {
        padding(2)
            .background(
            Circle().fill(color)
        )
    }
}
