import Foundation
import Combine
import SwiftUI

@MainActor
public enum NavigationManager {
    public static let eventPublisher = PassthroughSubject<Event, Never>()
    
    public enum Event {
        case url(URL)
    }
    
    public static func send(_ event: Event) {
        eventPublisher.send(event)
    }
    
    public static func send(url: URL) {
        send(.url(url))
    }
}

struct OnNavigationEvent: ViewModifier {
    let action: (NavigationManager.Event) -> Void

    init(_ action: @escaping (NavigationManager.Event) -> Void) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .onReceive(NavigationManager.eventPublisher) { event in
                action(event)
            }
    }
}

struct DismissOnNavigationEvent: ViewModifier {
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        content
            .onReceive(NavigationManager.eventPublisher) { _ in
                isPresented = false
            }
    }
}

extension View {
    public func onNavigationEvent(_ action: @escaping (NavigationManager.Event) -> Void) -> some View {
        modifier(OnNavigationEvent(action))
    }
    
    public func dismissOnNavigationEvent(isPresented: Binding<Bool>) -> some View {
        modifier(OnNavigationEvent { _ in
            isPresented.wrappedValue = false
        })
    }
}
