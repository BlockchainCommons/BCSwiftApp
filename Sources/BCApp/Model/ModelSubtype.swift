import SwiftUI

public struct ModelSubtype: Identifiable, Hashable {
    public var id: String
    public var icon: AnyView
    
    public init(id: String, icon: AnyView) {
        self.id = id
        self.icon = icon
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func ==(lhs: ModelSubtype, rhs: ModelSubtype) -> Bool {
        lhs.id == rhs.id
    }
}
