import SwiftUI

public struct UserGuideButton<Chapter: ChapterProtocol>: View {
    @State private var isPresented: Bool = false
    let openToChapter: Chapter?
    let showShortTitle: Bool
    let font: Font
    
    public init(openToChapter: Chapter? = nil, showShortTitle: Bool = false, font: Font = .title) {
        self.openToChapter = openToChapter
        self.showShortTitle = showShortTitle
        self.font = font
    }
    
    public var body: some View {
        Button {
            isPresented = true
        } label: {
            VStack {
                if showShortTitle,
                   let chapter = openToChapter,
                   let title = chapter.shortTitle
                {
                    HStack(spacing: 5) {
                        Image.guide
                        Text(title)
                    }
                    .font(.caption)
                    .lineLimit(1)
                } else {
                    Image.guide
                }
            }
            .padding(10)
        }
        .sheet(isPresented: $isPresented) {
            UserGuide(isPresented: $isPresented, openToChapter: openToChapter)
        }
        .font(font)
        .accessibility(label: Text("Documentation"))
    }
}

//#if DEBUG
//
//struct UserGuideButton_Preview: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            UserGuideButton<AppChapter>(openToChapter: nil)
//            UserGuideButton(openToChapter: AppChapter.aboutSeedTool)
//            UserGuideButton(openToChapter: AppChapter.whatIsALifehash)
//        }
//        .darkMode()
//    }
//}
//
//#endif
