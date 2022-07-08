import SwiftUI
import BCFoundation

public extension KeyType {
    var icon: AnyView {
        switch self {
        case .private:
            return Image.privateKey
                .icon()
                .foregroundColor(.black)
                .encircle(color: .lightRedBackground)
                .eraseToAnyView()
        case .public:
            return Image.publicKey
                .icon()
                .foregroundColor(.white)
                .encircle(color: Color.darkGreenBackground)
                .eraseToAnyView()
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
    public var label: AnyView {
        makeSegmentLabel(title: name, icon: icon)
    }
}
