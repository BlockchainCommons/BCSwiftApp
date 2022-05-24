import SwiftUI

public struct UserGuidePage<Chapter: ChapterProtocol>: View {
    let chapter: Chapter

    public init(chapter: Chapter) {
        self.chapter = chapter
    }

    public var body: some View {
        ScrollView {
            VStack {
                chapter.header
                Spacer(minLength: 10)
                chapter.markdown
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#if DEBUG
//
//struct InfoPage_Previews: PreviewProvider {
//    static var previews: some View {
//        UserGuidePage(chapter: AppChapter.licenseAndDisclaimer)
//            .darkMode()
//    }
//}
//
//#endif
