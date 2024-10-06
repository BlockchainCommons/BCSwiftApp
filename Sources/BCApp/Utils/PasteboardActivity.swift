import UIKit
import SwiftUI

public class PasteboardActivity: UIActivity {
    enum ActivityItem: Sendable {
        case string(String)
        case image(UIImage)
        case stringSource(ActivityStringSource)
        case imageSource(ActivityImageSource)
        
        init?(_ item: Any) {
            if let string = item as? String {
                self = .string(string)
            } else if let image = item as? UIImage {
                self = .image(image)
            } else if let source = item as? ActivityStringSource {
                self = .stringSource(source)
            } else if let source = item as? ActivityImageSource {
                self = .imageSource(source)
            } else {
                return nil
            }
        }
    }
    
    private var activityItems: [ActivityItem] = []
    
    public override class var activityCategory: UIActivity.Category {
        .action
    }

    public override var activityType: UIActivity.ActivityType? {
        .copyToPasteboard
    }
    
    public override var activityTitle: String? {
        "Copy to Clipboard"
    }
    
    public override var activityImage: UIImage? {
        UIImage.copy
    }
    
    public override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        activityItems.first(where: { ActivityItem($0) != nil }) != nil
    }
    
    public override func prepare(withActivityItems activityItems: [Any]) {
        self.activityItems = activityItems.compactMap { ActivityItem($0) }
    }
    
    public override func perform() {
        var success = false
        if let item = self.activityItems.first {
            DispatchQueue.main.sync {
                switch item {
                case .string(let string):
                    PasteboardCoordinator.shared.copyToPasteboard(string)
                case .image(let image):
                    PasteboardCoordinator.shared.copyToPasteboard(image)
                case .stringSource(let source):
                    PasteboardCoordinator.shared.copyToPasteboard(source.string)
                case .imageSource(let source):
                    PasteboardCoordinator.shared.copyToPasteboard(source.image)
                }
            }
            success = true
        }
        activityItems = []
        activityDidFinish(success)
    }
}
