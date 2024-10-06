import SwiftUI
import UIKit
@preconcurrency import PhotosUI

public extension View {
    func photoPicker(
        isPresented: Binding<Bool>,
        configuration: PHPickerConfiguration,
        completion: @escaping ([PHPickerResult]) -> Void
    ) -> some View {
        PhotoPicker(isPresented: isPresented, configuration: configuration, completion: completion)
    }
}

public struct PhotoPicker: UIViewControllerRepresentable {
    public class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        
        public init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isPresented = false
            parent.completion(results)
        }
    }
    
    @Binding var isPresented: Bool
    let configuration: PHPickerConfiguration
    let completion: ([PHPickerResult]) -> Void

    public init(isPresented: Binding<Bool>, configuration: PHPickerConfiguration, completion: @escaping ([PHPickerResult]) -> Void) {
        self._isPresented = isPresented
        self.configuration = configuration
        self.completion = completion
    }
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension NSItemProvider {
    func loadDataRepresentation(forTypeIdentifier typeIdentifier: String) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            loadDataRepresentation(forTypeIdentifier: typeIdentifier) { data, error in
                guard let data else {
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(throwing: GeneralError("Unknown error loading data."))
                    }
                    return
                }
                continuation.resume(returning: data)
            }
        }
    }
}

extension PHPickerResult: ImageLoader, @retroactive @unchecked Sendable {
    public func loadImage() async throws -> UIImage {
        let data = try await itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier)
        guard let image = UIImage(data: data) else {
            throw GeneralError("Could not form image from data at: \(self)")
        }
        return image
    }
}
