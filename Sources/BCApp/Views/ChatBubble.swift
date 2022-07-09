import SwiftUI

public struct ChatBubble<Content, Fill>: View where Content: View, Fill: View {
    let direction: Direction
    let fill: Fill
    let stroke: Color
    let lineWidth: Double
    @Binding var radius: Double
    let content: () -> Content
    @Environment(\.layoutDirection) var layoutDirection
    
    public enum Direction {
        case leading
        case trailing
    }
    
    public init(direction: Direction, fill: Fill, stroke: Color = .primary, lineWidth: Double = 0, radius: Binding<Double> = .constant(20), @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.fill = fill
        self.stroke = stroke
        self.lineWidth = lineWidth
        self.direction = direction
        self._radius = radius
    }
    
    public var body: some View {
        HStack {
            if direction == .trailing {
                Spacer()
            }
            ZStack {
                let bubble = BubbleShape(direction: direction, layoutDirection: layoutDirection, radius: radius)
                content()
                    .padding(max(10, radius / 2))
                    .padding(.leading, direction == .leading ? radius * 0.2 : 0)
                    .padding(.trailing, direction == .trailing ? radius * 0.2 : 0)
                    .background(
                        fill
                            .clipShape(bubble)
                    )
                    .overlay(
                        bubble.stroke(style: .init(lineWidth: lineWidth, lineJoin: .round, miterLimit: 2)).foregroundColor(stroke)
                    )
            }
            if direction == .leading {
                Spacer()
            }
        }
    }
    
    static func isLeftBubble(direction: Direction, layoutDirection: LayoutDirection) -> Bool {
        switch layoutDirection {
        case .leftToRight:
            switch direction {
            case .leading:
                return true
            case .trailing:
                return false
            }
        case .rightToLeft:
            switch direction {
            case .leading:
                return false
            case .trailing:
                return true
            }
        @unknown default:
            fatalError()
        }
    }
    
    struct BubbleShape: Shape {
        let direction: Direction
        let layoutDirection: LayoutDirection
        let radius: Double
        
        func path(in rect: CGRect) -> Path {
            if ChatBubble.isLeftBubble(direction: direction, layoutDirection: layoutDirection) {
                return getLeftBubblePath(in: rect, radius: radius)
            } else {
                return getRightBubblePath(in: rect, radius: radius)
            }
        }
        
        private func getLeftBubblePath(in rect: CGRect, radius: Double) -> Path {
            let width = rect.width
            let height = rect.height
            let minDimension = min(width, height)
            let r = min(radius, minDimension / 2)
            let scale = r / 20.0
            let inset = 4.0 * scale
            let cornerHandleLength = 8 * scale
            let path = Path { p in
                // bottom moving to right
                let bottomLeftStart = CGPoint(x: 25 * scale, y: height)
                let bottomRightCornerStart = CGPoint(x: width - r, y: height)
                let bottomRightCornerEnd = CGPoint(x: width, y: height - r)
                p.move(to: bottomLeftStart)
                p.addLine(to: bottomRightCornerStart)
                
                // bottom right corner
                p.addCurve(to: bottomRightCornerEnd,
                           control1: CGPoint(x: width - cornerHandleLength, y: height),
                           control2: CGPoint(x: width, y: height - cornerHandleLength))
                
                // right moving to top
                p.addLine(to: CGPoint(x: width, y: r))
                
                // top right corner
                p.addCurve(to: CGPoint(x: width - r, y: 0),
                           control1: CGPoint(x: width, y: cornerHandleLength),
                           control2: CGPoint(x: width - cornerHandleLength, y: 0))
                
                // top moving to left
                p.addLine(to: CGPoint(x: r, y: 0))
                
                // top left corner
                p.addCurve(to: CGPoint(x: inset, y: r),
                           control1: CGPoint(x: inset + cornerHandleLength, y: 0),
                           control2: CGPoint(x: inset, y: cornerHandleLength))
                
                // left moving to bottom
                p.addLine(to: CGPoint(x: inset, y: height - 11 * scale))
                
                // out to tip
                p.addCurve(to: CGPoint(x: 0, y: height),
                           control1: CGPoint(x: inset, y: height),
                           control2: CGPoint(x: 0, y: height))
                
                // tip to indent
                let indentX = inset * 3
                let indentY = height - inset
                p.addCurve(to: CGPoint(x: indentX, y: indentY),
                           control1: CGPoint(x: inset, y: height),
                           control2: CGPoint(x: indentX, y: height))
                
                // indent to bottom
                p.addCurve(to: bottomLeftStart,
                           control1: CGPoint(x: indentX, y: height),
                           control2: CGPoint(x: inset + r, y: height))
                
                p.closeSubpath()
            }
            return path
        }
        
        private func getRightBubblePath(in rect: CGRect, radius: Double) -> Path {
            let path = getLeftBubblePath(in: rect, radius: radius)
            let transform = CGAffineTransform(translationX: rect.width, y: 0)
                .scaledBy(x: -1, y: 1)
            return path.applying(transform)
        }
    }
}

public extension ChatBubble where Fill == EmptyView {
    init(direction: Direction, stroke: Color = .primary, lineWidth: Double = 0, radius: Binding<Double> = .constant(20), @ViewBuilder content: @escaping () -> Content) {
        self.init(direction: direction, fill: EmptyView(), stroke: stroke, lineWidth: lineWidth, radius: radius, content: content)
    }
}

#if DEBUG

struct ChatBubble_Host: View {
    @State private var radius = 20.0
    
    var body: some View {
        VStack {
            ChatBubble(direction: .leading, fill: Color.red.opacity(0.5), stroke: Color.red, lineWidth: 3, radius: $radius) {
                Text("Hello")
            }
            ChatBubble(direction: .trailing, fill: Color.green.opacity(0.5), stroke: Color.green, lineWidth: 3, radius: $radius) {
                Text("Hello")
            }
            ChatBubble(direction: .leading, fill: Color.blue.opacity(0.5), stroke: Color.blue, lineWidth: 3, radius: $radius) {
                Text("The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.")
            }
            ChatBubble(direction: .trailing, fill: Color.yellow.opacity(0.5), stroke: Color.yellow, lineWidth: 3, radius: $radius) {
                Text("The quick brown fox jumps over the lazy dog.")
            }
            ChatBubble(direction: .trailing, lineWidth: 1, radius: $radius) {
                Text("The quick brown fox jumps over the lazy dog.")
            }
            Slider(value: $radius, in: 0...60)
            Text("radius: \(radius)")
        }
    }
}
struct ChatBubble_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatBubble_Host()
            .padding()
            .darkMode()
    }
}

#endif
