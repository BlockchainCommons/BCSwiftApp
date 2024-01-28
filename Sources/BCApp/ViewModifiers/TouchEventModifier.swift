import SwiftUI

struct TouchEventModifier: ViewModifier {
    let didChangedPressed: (Bool) -> Void

    @GestureState private var isPressed = false

    public func body(content: Content) -> some View {
        let drag = DragGesture(minimumDistance: 0)
            .updating($isPressed) { (value, gestureState, transaction) in
                gestureState = true
            }

        return content
            .gesture(drag)
            .onChange(of: isPressed) { _, isPressed in
                self.didChangedPressed(isPressed)
            }
    }
}

public extension View {
    func onTouchEvent(didChangedPressed: @escaping (Bool) -> Void) -> some View {
        modifier(TouchEventModifier(didChangedPressed: didChangedPressed))
    }
}
