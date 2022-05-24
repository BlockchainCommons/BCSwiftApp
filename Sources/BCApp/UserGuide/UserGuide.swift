import SwiftUI
import WolfSwiftUI

public struct UserGuide<Chapter: ChapterProtocol>: View {
    @Binding var isPresented: Bool
    @State private var openToChapter: Chapter?
    @State private var currentChapter: Chapter?
    
    public init(isPresented: Binding<Bool>, openToChapter: Chapter? = nil) {
        self._isPresented = isPresented
        self._openToChapter = State(initialValue: openToChapter)
    }
    
    public var body: some View {
        NavigationView {
            List {
                Chapter.appLogo
                ForEach(Chapter.allCases) {
                    UserGuideLink(isPresented: $isPresented, chapter: $0, currentChapter: $currentChapter)
                }
            }
            .font(.body)
            .navigationTitle("Contents")
            .navigationBarItems(
                trailing:
                    DoneButton($isPresented)
                    .keyboardShortcut(.cancelAction)
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if openToChapter != nil {
                currentChapter = openToChapter
                openToChapter = nil
            }
        }
    }
    
    func section<Content>(title: String, content: Content) -> some View where Content: View {
        NavigationLink(destination:
                        content
                        .navigationBarItems(trailing: DoneButton($isPresented))
        ) {
            Text(title)
        }
    }
}

//#if DEBUG
//
//struct UserGuide_Previews: PreviewProvider {
//    static var previews: some View {
//        UserGuide<AppChapter>(isPresented: .constant(true), openToChapter: .whatIsSSKR)
//            .darkMode()
//    }
//}
//
//#endif
