import SwiftUI
import AVFoundation

public protocol CameraProtocol: AnyObject, Equatable {
    var uniqueID: String { get }
    var localizedName: String { get }
    var position: AVCaptureDevice.Position { get }
}

extension CameraProtocol {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.uniqueID == rhs.uniqueID
    }
}

extension AVCaptureDevice: CameraProtocol { }

public struct CameraSelector<Camera>: View where Camera: CameraProtocol {
    @Binding var cameras: [Camera]
    @Binding var selectedCamera: Camera?
    
    public init(cameras: Binding<[Camera]>, selectedCamera: Binding<Camera?>) {
        self._cameras = cameras
        self._selectedCamera = selectedCamera
    }
    
    public var body: some View {
        if hasNoChoices {
            placeholder
        } else if isMobile {
            flipButton
        } else {
            menu
        }
    }
    
    private var placeholder: some View {
        icon()
            .foregroundColor(.secondary)
    }
    
    private var flipButton: some View {
        Button {
            nextCamera()
        } label: {
            switch selectedCamera?.position {
            case .front?:
                icon(image: Image.frontCamera)
                    .eraseToAnyView()
            case .back?:
                icon(image: Image.backCamera)
                    .eraseToAnyView()
            default:
                icon()
                    .foregroundColor(.secondary)
                    .eraseToAnyView()
            }
        }
    }
    
    private var menu: some View {
        let selectedCameraID = Binding<String>(
            get: {
                return selectedCamera?.uniqueID ?? "nil"
            },
            set: { newCameraID in
                selectedCamera = cameras.first(where: { camera in
                    camera.uniqueID == newCameraID
                })!
            }
        )
        return Menu {
            Picker("Camera", selection: selectedCameraID) {
                ForEach(cameras, id: \.uniqueID) { device in
                    Text(device.localizedName)
                }
            }
        } label: {
            icon()
        }
    }
    
    private func icon(image: Image = Image.camera) -> some View {
        image
            .resizable()
            .aspectRatio(1, contentMode: .fill)
            .frame(width: 30, height: 30)
            .padding(2)
    }
    
    private var hasNoChoices: Bool {
        cameras.count <= 1
    }
    
    private func hasCameraAtPosition(_ position: AVCaptureDevice.Position) -> Bool {
        cameras.contains(where: { $0.position == position })
    }
    
    private var isMobile: Bool {
        cameras.count == 2 && hasCameraAtPosition(.front) && hasCameraAtPosition(.back)
    }
    
    private var indexOfCurrentCamera: Int? {
        guard let selectedCamera = selectedCamera else {
            return nil
        }
        return cameras.firstIndex(where: { $0.uniqueID == selectedCamera.uniqueID })
    }
    
    private func nextCamera() {
        guard !hasNoChoices else {
            return
        }
        let currentIndex = indexOfCurrentCamera ?? 0
        let nextIndex = (currentIndex + 1) % cameras.count
        selectedCamera = cameras[nextIndex]
    }
}

#if DEBUG

class MockCamera: CameraProtocol {
    let uniqueID: String
    let localizedName: String
    let position: AVCaptureDevice.Position
    
    init(_ seedID: String, _ name: String, _ position: AVCaptureDevice.Position) {
        self.uniqueID = seedID
        self.localizedName = name
        self.position = position
    }
}

struct CameraClient<Camera>: View where Camera: CameraProtocol {
    @State var cameras: [Camera]
    @State var selectedCamera: Camera?
    
    init(_ cameras: [Camera], _ selectedCamera: Camera?) {
        _cameras = State(initialValue: cameras)
        _selectedCamera = State(initialValue: selectedCamera)
    }
    
    var body: some View {
        HStack {
            CameraSelector(cameras: $cameras, selectedCamera: $selectedCamera)
            Text(selectedCamera?.localizedName ?? "none")
        }
    }
}

struct CameraSelector_Previews: PreviewProvider {
    static let builtIn = MockCamera("A", "Built In Camera", .unspecified)
    static let webcam = MockCamera("B", "Webcam", .unspecified)
    static let frontCam = MockCamera("C", "Front Camera", .front)
    static let backCam = MockCamera("D", "Back Camera", .back)
    
    static let nocams: [MockCamera] = []
    static let builtInOnly = [builtIn]
    static let desktop = [builtIn, webcam]
    static let mobile = [frontCam, backCam]
    
    static var previews: some View {
        VStack {
            CameraClient(nocams, nil)
            CameraClient(builtInOnly, builtIn)
            CameraClient(desktop, builtIn)
            CameraClient(desktop, nil)
            CameraClient(mobile, backCam)
        }
    }
}
#endif
