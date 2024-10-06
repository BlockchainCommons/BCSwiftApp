import SwiftUI

public extension Asset {
    @MainActor
    var image: some View {
        @ViewBuilder
        get {
            switch self {
            case .btc:
                Symbol.bitcoin
            case .eth:
                Symbol.ethereum
            case .xtz:
                Symbol.tezos
            }
        }
    }

    @MainActor
    var icon: some View {
        @ViewBuilder
        get {
            image
                .accessibility(label: Text(self.name))
        }
    }
    
    @MainActor
    var subtype: ModelSubtype {
        ModelSubtype(id: id, icon: icon.eraseToAnyView())
    }
}

@MainActor
extension Asset: Segment {
    public var view: AnyView {
        makeSegmentLabel(title: name, icon: icon.eraseToAnyView())
    }
    
    public var accessibilityLabel: String {
        name
    }
}
