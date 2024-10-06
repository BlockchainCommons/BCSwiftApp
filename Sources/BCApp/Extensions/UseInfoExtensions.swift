import Foundation
import BCFoundation

public extension UseInfo {
    @MainActor
    var subtypes: [ModelSubtype] {
        switch asset {
        case .btc, .eth:
            return [ asset.subtype, network.subtype ]
        case .xtz:
            return [ asset.subtype ]
        }
    }
}
