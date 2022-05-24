import SwiftUI
import MarkdownUI

public protocol ChapterProtocol: CaseIterable, Identifiable, Hashable {
    var name: String { get }
    var header: AnyView? { get }
    var shortTitle: String? { get }
    var title: String { get }
    var markdown: Markdown { get }
    var markdownChapter: MarkdownChapter { get }
    
    static var allCases: [Self] { get }
    static var appLogo: AnyView { get }
}
