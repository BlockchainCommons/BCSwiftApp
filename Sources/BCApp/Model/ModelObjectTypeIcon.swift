import SwiftUI

public struct ModelObjectTypeIcon: View {
    public let type: ModelObjectType?

    public var body: some View {
        (type?.icon ?? Image.missing.icon().eraseToAnyView())
    }
}

public extension Image {
    func icon() -> some View {
        resizable()
            .aspectRatio(contentMode: .fit)
    }
}
