import SwiftUI
import UIKit
import UniformTypeIdentifiers

public struct DocumentPickerConfiguration {
    public var documentTypes: [UTType]
    public var asCopy: Bool
    public var allowsMultipleSelection: Bool
    public var directoryURL: URL?

    public init(documentTypes: [UTType] = [], asCopy: Bool = false, allowsMultipleSelection: Bool = false, directoryURL: URL? = nil) {
        self.documentTypes = documentTypes
        self.asCopy = asCopy
        self.allowsMultipleSelection = allowsMultipleSelection
        self.directoryURL = directoryURL
    }
}

public extension View {
    func documentPicker(
        isPresented: Binding<Bool>,
        configuration: DocumentPickerConfiguration,
        completion: @escaping ([URL]) -> Void
    ) -> some View {
        DocumentPicker(isPresented: isPresented, configuration: configuration, completion: completion)
    }
}


public struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let configuration: DocumentPickerConfiguration
    let completion: ([URL]) -> ()

    public class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        // KLUDGE: This is only necessary under Catalyst. Apparently the
        // delegate methods don't get called because the coordinator gets
        // deallocated to early. Here we create a strong reference to it
        // that we only release after a successful delegate callback.
        static var coordinator: DocumentPicker.Coordinator?

        init(_ parent: DocumentPicker) {
            self.parent = parent
            super.init()
            Self.coordinator = self
        }

        public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.isPresented = false
            parent.completion(urls)
            Self.coordinator = nil
        }
        
        public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.isPresented = false
            parent.completion([])
            Self.coordinator = nil
        }
    }
    
    public init(
        isPresented: Binding<Bool>,
        configuration: DocumentPickerConfiguration,
        completion: @escaping ([URL]) -> ()
    ) {
        self._isPresented = isPresented
        self.configuration = configuration
        self.completion = completion
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: configuration.documentTypes, asCopy: configuration.asCopy)
        controller.allowsMultipleSelection = configuration.allowsMultipleSelection
        controller.directoryURL = configuration.directoryURL
        controller.delegate = context.coordinator
        return controller
    }
    
    public func updateUIViewController(_ presentingController: UIViewController, context: Context) {
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
