import Foundation
import SwiftUI
import Combine
import WolfBase

public enum Validation {
    case valid
    case invalid(String?)
}

public extension Validation {
    var isValid: Bool {
        switch self {
        case .valid:
            return true
        default:
            return false
        }
    }
}

public typealias ValidationPublisher = AnyPublisher<Validation, Never>

extension Publisher {
    public func debounceField() -> Publishers.Debounce<Self, RunLoop> {
        debounce(for: .seconds(0.5), scheduler: RunLoop.main)
    }
}

extension Publisher {
    public func validate() -> ValidationPublisher where Failure == Never {
        map { _ in Validation.valid }
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output == String, Failure == Never {
    public func trimWhitespace() -> AnyPublisher<String, Never> {
        map { $0.trim() }
        .eraseToAnyPublisher()
    }
    
    public func removeWhitespaceRuns() -> AnyPublisher<String, Never> {
        map { $0.removeWhitespaceRuns() }
        .eraseToAnyPublisher()
    }
    
    public func convertNonwordToSpace() -> AnyPublisher<String, Never> {
        map { $0.convertNonwordToSpace() }
        .eraseToAnyPublisher()
    }
}

extension Publisher where Output : Collection {
    public func isEmpty() -> Publishers.Map<Self, Bool> {
        map { $0.isEmpty }
    }

    public func validateNotEmpty(_ message: String? = nil) -> ValidationPublisher where Failure == Never {
        isEmpty().map {
            $0 ? .invalid(message) : .valid
        }
        .eraseToAnyPublisher()
    }
}

struct ValidationModifier: ViewModifier {
    @State var latestValidation: Validation = .valid
    public let validationPublisher: ValidationPublisher

    public func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            content
            validationMessage
        }.onReceive(validationPublisher) { validation in
            withAnimation {
                self.latestValidation = validation
            }
        }
    }

    public var validationMessage: some View {
        switch latestValidation {
        case .valid:
            return AnyView(EmptyView())
        case .invalid(let message):
            let message = message ?? "Invalid."
            let text = Text(markdown: message)
                .foregroundColor(Color.red)
                .font(.caption)
            return AnyView(text)
        }
    }
}

extension View {
    public func validation(_ validationPublisher: ValidationPublisher) -> some View {
        modifier(ValidationModifier(validationPublisher: validationPublisher))
    }
}
