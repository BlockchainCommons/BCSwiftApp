import SwiftUI
import BCFoundation

public struct ModelObjectType {
    public let name: String
    public let type: String
    public let icon: AnyView
    
    public init(name: String, type: String, icon: AnyView) {
        self.name = name
        self.type = type
        self.icon = icon
    }
}

@MainActor
public extension ModelObjectType {
    static let seed = ModelObjectType(name: "Seed", type: "Seed", icon: Image.seed.icon().eraseToAnyView())
    static let privateHDKey = ModelObjectType(name: "Private HD Key", type: "PrivateHDKey", icon: KeyType.private.icon.eraseToAnyView())
    static let publicHDKey = ModelObjectType(name: "Public HD Key", type: "PublicHDKey", icon: KeyType.public.icon.eraseToAnyView())
    static let privateECKey = ModelObjectType(name: "Private Key", type: "PrivateECKey", icon: KeyType.private.icon.eraseToAnyView())
    static let address = ModelObjectType(name: "Address", type: "Address", icon: Image.address.icon().eraseToAnyView())
}
