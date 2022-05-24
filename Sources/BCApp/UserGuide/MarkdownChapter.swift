import Foundation
import MarkdownUI

public struct MarkdownChapter {
    public let title: String?
    public let body: String
    
    public init(name: String) {
        let url = Bundle.main.url(forResource: name, withExtension: "md", subdirectory: "Markdown")!
        let content = try! String(contentsOf: url)
        let lines = content.split(separator: "\n", omittingEmptySubsequences: false)
        let firstLine = lines.first!
        if firstLine.hasPrefix("# ") {
            self.title = String(firstLine.dropFirst(2))
//            lines.removeFirst()
        } else {
            self.title = nil
        }
        self.body = lines.joined(separator: "\n")
    }
}
