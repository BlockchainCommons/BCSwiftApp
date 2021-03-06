import SwiftUI
@_exported import BCFoundation

public extension Network {
    var image: Image {
        switch self {
        case .mainnet:
            return .mainnet
        case .testnet:
            return .testnet
        }
    }
    
    var icon: AnyView {
        image
            .accessibility(label: Text(self.name))
            .eraseToAnyView()
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
        ModelSubtype(id: id, icon: icon)
    }
}

extension Network: Segment {
    public var label: AnyView {
        makeSegmentLabel(title: name, icon: icon)
    }
}
