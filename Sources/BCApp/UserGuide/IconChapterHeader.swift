import SwiftUI

public struct IconChapterHeader: View {
    let image: Image

    public init(image: Image) {
        self.image = image
    }

    public var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 100)
    }
}
