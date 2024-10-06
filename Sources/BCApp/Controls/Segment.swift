import SwiftUI

@MainActor
public protocol Segment: Identifiable, Equatable {
    var view: AnyView { get }
    var accessibilityLabel: String { get }
}

@MainActor
public func makeSegmentLabel<Icon>(title: String? = nil, icon: Icon? = nil) -> AnyView where Icon: View {
    HStack {
        icon
        if let title = title {
            Text(title)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
    .eraseToAnyView()
}

struct BasicSegment: Segment {
    let id: UUID = UUID()
    let title: String?
    let icon: AnyView?
    var accessibilityLabel: String {
        title ?? "Untitled"
    }
    
    init(title: String) {
        self.icon = nil
        self.title = title
    }

    init(title: String? = nil, icon: AnyView) {
        self.icon = icon
        self.title = title
    }
    
    var view: AnyView {
        makeSegmentLabel(title: title, icon: icon)
    }
    
    nonisolated static func ==(lhs: BasicSegment, rhs: BasicSegment) -> Bool {
        return lhs.id == rhs.id
    }
}
