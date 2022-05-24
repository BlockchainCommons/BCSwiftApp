import SwiftUI

public protocol Printable: Equatable {
    associatedtype Page: View
    
    var name: String { get }
    var printExportFields: ExportFields { get }
    var printPages: [Page] { get }
    var jobName: String { get }
}

public extension Printable {
    var jobName: String {
        Export(name: name, fields: printExportFields).filename
    }
}

public struct PrintablePages: Printable {
    public let id = UUID()
    public let name: String
    public let printExportFields: ExportFields
    public let printables: [AnyPrintable]
    
    public init(name: String, printExportFields: ExportFields, printables: [AnyPrintable]) {
        self.name = name
        self.printExportFields = printExportFields
        self.printables = printables
    }
    
    public var printPages: [AnyView] {
        var views: [AnyView] = []
        
        for p in printables {
            views.append(contentsOf: p.printPages)
        }
        
        return views
    }
    
    public static func ==(lhs: PrintablePages, rhs: PrintablePages) -> Bool {
        lhs.id == rhs.id
    }
}

public struct AnyPrintable: Printable {
    public static func == (lhs: AnyPrintable, rhs: AnyPrintable) -> Bool {
        lhs.id == rhs.id
    }
    
    public typealias Page = AnyView
    private let _name: () -> String
    private let _printExportFields: () -> ExportFields
    let _printPages: () -> [AnyView]
    public let id = UUID()

    public init<P: Printable>(_ p: P) {
        self._name = {
            p.name
        }

        self._printExportFields = {
            p.printExportFields
        }

        self._printPages = {
            p.printPages.map { $0.eraseToAnyView() }
        }
    }

    public var name: String {
        _name()
    }
    
    public var printExportFields: ExportFields {
        _printExportFields()
    }

    public var printPages: [AnyView] {
        _printPages()
    }
}

public extension Printable {
    func eraseToAnyPrintable() -> AnyPrintable {
        AnyPrintable(self)
    }
}
