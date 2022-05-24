import SwiftUI
import BCFoundation
import LinkPresentation
import Combine

public class ActivityParams {
    let items: [Any]
    let activities: [UIActivity]?
    let completion: UIActivityViewController.CompletionWithItemsHandler?
    let excludedActivityTypes: [UIActivity.ActivityType]?

    init(
        items: [Any],
        activities: [UIActivity]? = nil,
        completion: UIActivityViewController.CompletionWithItemsHandler? = nil,
        excludedActivityTypes: [UIActivity.ActivityType]? = nil
    ) {
        self.items = items
        self.activities = [activities, [PasteboardActivity()]].compactMap { $0 }.flatMap { $0 }
        self.completion = completion
        self.excludedActivityTypes = excludedActivityTypes
    }
}

extension ActivityParams {
    public convenience init(_ string: String, name: String, fields: ExportFields? = nil) {
        self.init(items: [ActivityStringSource(string: string, export: Export(name: name, fields: fields))])
    }
    
    public convenience init(_ image: UIImage, name: String, fields: ExportFields? = nil) {
        self.init(items: [ActivityImageSource(image: image, export: Export(name: name, fields: fields))])
    }
    
    public convenience init(_ ur: UR, name: String, fields: ExportFields? = nil) {
        self.init(ur.string, name: name, fields: fields)
    }
    
    public convenience init(_ data: Data, name: String, fields: ExportFields? = nil) {
        self.init(items: [ActivityDataSource(data: data, export: Export(name: name, fields: fields))], excludedActivityTypes: [.copyToPasteboard])
    }
}

extension UIActivity.ActivityType {
    public static let saveToFiles: UIActivity.ActivityType = .init(rawValue: "com.apple.DocumentManagerUICore.SaveToFiles")
}

public class ActivityStringSource: UIActivityItemProvider {
    public let string: String
    public let url: URL
    public let export: Export
    
    public init(string: String, export: Export) {
        self.string = string
        self.export = export
        let tempDir = FileManager.default.temporaryDirectory
        self.url = tempDir.appendingPathComponent("\(export.filename).txt")
        super.init(placeholderItem: export.placeholder)
        try? string.utf8Data.write(to: url)
    }
    
    deinit {
        try? FileManager.default.removeItem(at: url)
    }
    
    public override func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if activityType == .saveToFiles {
            return url
        } else {
            return string
        }
    }
    
    public override func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = export.placeholder
        return metadata
    }
}

public class ActivityImageSource: UIActivityItemProvider {
    public let url: URL
    public let image: UIImage
    public let export: Export

    public init(image: UIImage, export: Export) {
        self.image = image
        self.export = export
        let tempDir = FileManager.default.temporaryDirectory
        self.url = tempDir.appendingPathComponent("\(export.filename).png")
        super.init(placeholderItem: image)
        try? image.pngData()!.write(to: url)
    }
    
    deinit {
        try? FileManager.default.removeItem(at: url)
    }
    
    public override func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if activityType == .copyToPasteboard {
            return image
        } else {
            return url
        }
    }

    public override func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let imageProvider = NSItemProvider(object: image)
        let metadata = LPLinkMetadata()
        metadata.imageProvider = imageProvider
        metadata.title = export.placeholder
        return metadata
    }
}

public class ActivityDataSource: UIActivityItemProvider {
    public let url: URL
    public let export: Export

    public init(data: Data, export: Export) {
        self.export = export
        let tempDir = FileManager.default.temporaryDirectory
        self.url = tempDir.appendingPathComponent(export.filename)

        super.init(placeholderItem: export.placeholder)

        try? data.write(to: url)
    }
    
    deinit {
        try? FileManager.default.removeItem(at: url)
    }

    public override var item: Any {
        url
    }
    
//    override func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
//        return "PSBT"
//    }

    public override func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = export.placeholder
        return metadata
    }
}

public struct ActivityView: UIViewControllerRepresentable {
    @Binding var params: ActivityParams?

    public init(params: Binding<ActivityParams?>) {
        _params = params
    }

    public func makeUIViewController(context: Context) -> ActivityViewControllerWrapper {
        ActivityViewControllerWrapper() {
            params = nil
        }
    }

    public func updateUIViewController(_ uiViewController: ActivityViewControllerWrapper, context: Context) {
        uiViewController.params = params
        uiViewController.updateState()
    }
}

public final class ActivityViewControllerWrapper: UIViewController {
    var params: ActivityParams?
    let completion: () -> Void
    var eventListener: AnyCancellable?
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
        
        self.eventListener = NavigationManager.eventPublisher.sink { [weak self] event in
            guard
                let self = self,
                let controller = self.presentedViewController
            else {
                return
            }
            controller.dismiss(animated: true)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        updateState()
    }

    fileprivate func updateState() {
        guard presentedViewController == nil, let myParams = params else {
            return
        }

        let controller = UIActivityViewController(activityItems: myParams.items, applicationActivities: myParams.activities)
        controller.popoverPresentationController?.sourceView = view
        controller.excludedActivityTypes = myParams.excludedActivityTypes
        controller.completionWithItemsHandler = { [weak self] (activityType, success, items, error) in
            myParams.completion?(activityType, success, items, error)
            self?.completion()
        }
        present(controller, animated: true, completion: nil)
    }

}

#if DEBUG

struct ActivityViewTest: View {
    @State private var activityParams: ActivityParams?
    var body: some View {
        VStack {
            Button("Share Text") {
                self.activityParams = ActivityParams("Mock text", name: "Mock Filename")
            }.background(ActivityView(params: $activityParams))

            Button("Share Data") {
                self.activityParams = ActivityParams("Mock text".data(using: .utf8)!, name: "Sample Data")
            }.background(ActivityView(params: $activityParams))
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityViewTest()
//            .previewDevice("iPhone 8 Plus")
    }
}

#endif
