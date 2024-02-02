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
    @State var latestGuidance: AttributedString? = nil
    public let validationPublisher: ValidationPublisher
    public let guidancePublisher: PassthroughSubject<AttributedString?, Never>
    
    init(validationPublisher: ValidationPublisher, guidancePublisher: PassthroughSubject<AttributedString?, Never>?) {
        self.validationPublisher = validationPublisher
        self.guidancePublisher = guidancePublisher ?? PassthroughSubject<AttributedString?, Never>()
    }

    public func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            content
            if let latestGuidance {
                Text(latestGuidance)
            } else {
                validationMessage
            }
        }.onReceive(validationPublisher) { validation in
            withAnimation {
                self.latestValidation = validation
            }
        }.onReceive(guidancePublisher) { guidanceString in
            if guidanceString != self.latestGuidance {
                withAnimation {
                    self.latestGuidance = guidanceString
                }
            }
        }
    }

    @ViewBuilder
    public var validationMessage: some View {
        if latestGuidance == nil {
            switch latestValidation {
            case .valid:
                EmptyView()
            case .invalid(let message):
                let message = message ?? "Invalid."
                Text(markdown: message)
                    .foregroundColor(Color.red)
                    .font(.caption)
            }
        }
    }
}

extension View {
    public func validation(_ validationPublisher: ValidationPublisher, guidancePublisher: PassthroughSubject<AttributedString?, Never>? = nil) -> some View {
        modifier(ValidationModifier(validationPublisher: validationPublisher, guidancePublisher: guidancePublisher))
    }
}
