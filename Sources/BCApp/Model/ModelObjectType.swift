import SwiftUI
import BCFoundation

public enum ModelObjectType {
    case seed
    case privateHDKey
    case publicHDKey
    case privateECKey
    case address

    public var icon: AnyView {
        switch self {
        case .seed:
            return Image.seed.icon().eraseToAnyView()
        case .privateHDKey:
            return KeyType.private.icon
        case .publicHDKey:
            return KeyType.public.icon
        case .privateECKey:
            return KeyType.private.icon
        case .address:
            return Image.address.icon().eraseToAnyView()
        }
    }
    
    public var name: String {
        switch self {
        case .seed:
            return "Seed"
        case .privateHDKey:
            return "Private HD Key"
        case .publicHDKey:
            return "Public HD Key"
        case .privateECKey:
            return "Private Key"
        case .address:
            return "Address"
        }
    }
    
    public var type: String {
        switch self {
        case .seed:
            return "Seed"
        case .privateHDKey:
            return "PrivateHDKey"
        case .publicHDKey:
            return "PublicHDKey"
        case .privateECKey:
            return "PrivateECKey"
        case .address:
            return "Address"
        }
    }
}
