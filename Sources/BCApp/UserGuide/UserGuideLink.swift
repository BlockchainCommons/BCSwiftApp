import SwiftUI
import WolfSwiftUI

public struct UserGuideLink<Chapter: ChapterProtocol>: View {
    let chapter: Chapter
    @Binding var isPresented: Bool
    @Binding var currentChapter: Chapter?
    
    public init(isPresented: Binding<Bool>, chapter: Chapter, currentChapter: Binding<Chapter?>) {
        self._isPresented = isPresented
        self._currentChapter = currentChapter
        self.chapter = chapter
    }
    
    public var body: some View {
        NavigationLink(
            destination: LazyView(UserGuidePage(chapter: chapter).navigationBarItems(trailing: DoneButton($isPresented))),
            tag: chapter,
            selection: $currentChapter)
        {
            Text(chapter.title)
        }
        .accessibility(label: Text(chapter.title))
    }
}
