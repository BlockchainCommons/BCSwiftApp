import SwiftUI

public struct ChatBubble<Content, Background>: View where Content: View, Background: View {
    let direction: Direction
    let background: Background
    let content: () -> Content
    @Environment(\.layoutDirection) var layoutDirection

    public enum Direction {
        case leading
        case trailing
    }

    public init(direction: Direction, background: Background, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.background = background
        self.direction = direction
    }
    
    public var body: some View {
        HStack {
            if direction == .trailing {
                Spacer()
            }
            content()
                .padding(.leading, direction == .leading ? 5 : 0)
                .padding(.trailing, direction == .trailing ? 5 : 0)
                .background(background)
                .clipShape(BubbleShape(direction: direction, layoutDirection: layoutDirection))
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
        
        func path(in rect: CGRect) -> Path {
            if ChatBubble.isLeftBubble(direction: direction, layoutDirection: layoutDirection) {
                return getLeftBubblePath(in: rect)
            } else {
                return getRightBubblePath(in: rect)
            }
        }
        
        private func getLeftBubblePath(in rect: CGRect) -> Path {
            let width = rect.width
            let height = rect.height
            let path = Path { p in
                p.move(to: CGPoint(x: 25, y: height))
                p.addLine(to: CGPoint(x: width - 20, y: height))
                p.addCurve(to: CGPoint(x: width, y: height - 20),
                           control1: CGPoint(x: width - 8, y: height),
                           control2: CGPoint(x: width, y: height - 8))
                p.addLine(to: CGPoint(x: width, y: 20))
                p.addCurve(to: CGPoint(x: width - 20, y: 0),
                           control1: CGPoint(x: width, y: 8),
                           control2: CGPoint(x: width - 8, y: 0))
                p.addLine(to: CGPoint(x: 21, y: 0))
                p.addCurve(to: CGPoint(x: 4, y: 20),
                           control1: CGPoint(x: 12, y: 0),
                           control2: CGPoint(x: 4, y: 8))
                p.addLine(to: CGPoint(x: 4, y: height - 11))
                p.addCurve(to: CGPoint(x: 0, y: height),
                           control1: CGPoint(x: 4, y: height - 1),
                           control2: CGPoint(x: 0, y: height))
                p.addLine(to: CGPoint(x: -0.05, y: height - 0.01))
                p.addCurve(to: CGPoint(x: 11.0, y: height - 4.0),
                           control1: CGPoint(x: 4.0, y: height + 0.5),
                           control2: CGPoint(x: 8, y: height - 1))
                p.addCurve(to: CGPoint(x: 25, y: height),
                           control1: CGPoint(x: 16, y: height),
                           control2: CGPoint(x: 20, y: height))
                
            }
            return path
        }
        
        private func getRightBubblePath(in rect: CGRect) -> Path {
            let width = rect.width
            let height = rect.height
            let path = Path { p in
                p.move(to: CGPoint(x: 25, y: height))
                p.addLine(to: CGPoint(x:  20, y: height))
                p.addCurve(to: CGPoint(x: 0, y: height - 20),
                           control1: CGPoint(x: 8, y: height),
                           control2: CGPoint(x: 0, y: height - 8))
                p.addLine(to: CGPoint(x: 0, y: 20))
                p.addCurve(to: CGPoint(x: 20, y: 0),
                           control1: CGPoint(x: 0, y: 8),
                           control2: CGPoint(x: 8, y: 0))
                p.addLine(to: CGPoint(x: width - 21, y: 0))
                p.addCurve(to: CGPoint(x: width - 4, y: 20),
                           control1: CGPoint(x: width - 12, y: 0),
                           control2: CGPoint(x: width - 4, y: 8))
                p.addLine(to: CGPoint(x: width - 4, y: height - 11))
                p.addCurve(to: CGPoint(x: width, y: height),
                           control1: CGPoint(x: width - 4, y: height - 1),
                           control2: CGPoint(x: width, y: height))
                p.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
                p.addCurve(to: CGPoint(x: width - 11, y: height - 4),
                           control1: CGPoint(x: width - 4, y: height + 0.5),
                           control2: CGPoint(x: width - 8, y: height - 1))
                p.addCurve(to: CGPoint(x: width - 25, y: height),
                           control1: CGPoint(x: width - 16, y: height),
                           control2: CGPoint(x: width - 20, y: height))
                
            }
            return path
        }
    }
}
