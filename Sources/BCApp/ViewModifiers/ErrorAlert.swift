import SwiftUI

public struct ErrorAlert: ViewModifier {
    public struct Info: Equatable {
        let title: String
        let message: String

        public init(title: String, message: String) {
            self.title = title
            self.message = message
        }
    }
    
    @Binding var info: Info?
    
    init(info: Binding<Info?>) {
        self._info = info
    }
    
    public func body(content: Content) -> some View {
        let isPresented = Binding<Bool> {
            info != nil
        } set: { _, _ in
            // empty
        }

        content
            .alert(info?.title ?? "Title", isPresented: isPresented) {
                Button(role: .cancel) {
                    info = nil
                } label: {
                    Text("OK")
                }
            } message: {
                Text(markdown: info?.message ?? "Message")
            }
            .onChange(of: info) { newValue in
                if newValue != nil {
                    Haptic.error()
                }
            }
    }
}

public extension View {
    func messageAlert(_ info: Binding<ErrorAlert.Info?>) -> some View {
        modifier(ErrorAlert(info: info))
    }
}
