import SwiftUI

public extension Asset {
    var image: some View {
        @ViewBuilder
        get {
            switch self {
            case .btc:
                Symbol.bitcoin
            case .eth:
                Symbol.ethereum
            }
        }
    }

    var icon: some View {
        @ViewBuilder
        get {
            image
                .accessibility(label: Text(self.name))
        }
    }
    
    var subtype: ModelSubtype {
        ModelSubtype(id: id, icon: icon.eraseToAnyView())
    }
}

extension Asset: Segment {
    public var label: AnyView {
        makeSegmentLabel(title: name, icon: icon.eraseToAnyView())
    }
}
