import Foundation

public typealias ExportFields = [Export.Field: String]

public struct Export {
    private let name: String
    private let fields: ExportFields
    
    public enum Field {
        case placeholder
        case rootID
        case id
        case type
        case subtype
        case fragment
        case format
    }
    
    public init(name: String, fields: ExportFields? = nil) {
        self.name = name
        self.fields = fields ?? [:]
    }
    
    public var filename: String {
        [
            fields[.rootID],
            fields[.id],
            name,
            fields[.type],
            fields[.subtype],
            fields[.fragment],
            fields[.format],
        ]
            .compactMap { $0 }
            .joined(separator: "-")
            .replacingOccurrences(of: "/", with: "_")
    }
    
    public var placeholder: String {
        fields[.placeholder] ?? filename
    }
}
