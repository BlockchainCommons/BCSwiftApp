import SwiftUI

public extension Network {
    var image: Image {
        switch self {
        case .mainnet:
            return .mainnet
        case .testnet:
            return .testnet
        }
    }

    @ViewBuilder
    var icon: some View {
        image
            .accessibility(label: Text(self.name))
    }
    
    var name: String {
        switch self {
        case .mainnet:
            return "MainNet"
        case .testnet:
            return "TestNet"
        }
    }
    
    var textSuffix: Text {
        return Text(" ") + Text(image)
    }
    
    var iconWithName: some View {
        HStack {
            icon
            Text(name)
        }
    }

    var subtype: ModelSubtype {
        ModelSubtype(id: id, icon: icon.eraseToAnyView())
    }
}

extension Network: Segment {
    public var label: AnyView {
        makeSegmentLabel(title: name, icon: icon)
    }
}
