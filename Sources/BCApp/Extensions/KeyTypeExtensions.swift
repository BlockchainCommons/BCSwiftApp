import SwiftUI
import BCFoundation

@MainActor
public extension KeyType {
    @ViewBuilder
    var icon: some View {
        switch self {
        case .private:
            Image.privateKey
                .icon()
                .foregroundColor(.black)
                .encircle(color: .lightRedBackground)
        case .public:
            Image.publicKey
                .icon()
                .foregroundColor(.white)
                .encircle(color: Color.darkGreenBackground)
        }
    }
    
    var image: Image {
        switch self {
        case .private:
            return Image.privateKey
        case .public:
            return Image.publicKey
        }
    }
}

extension KeyType: Segment {
    public var view: AnyView {
        makeSegmentLabel(title: name, icon: icon)
    }
    
    public var accessibilityLabel: String {
        name
    }
}
