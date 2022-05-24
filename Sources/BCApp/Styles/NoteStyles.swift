import SwiftUI

public struct Note<Icon, Content>: View where Icon: View, Content: View {
    let icon: Icon
    let content: Content
    
    public init(icon: Icon, content: Content) {
        self.icon = icon
        self.content = content
    }
    
    public var body: some View {
        HStack(alignment: .firstTextBaseline) {
            icon
            content
                .fixedVertical()
            Spacer()
        }
    }
}

public struct DeveloperFunctions<Content>: View where Content: View {
    let content: Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        Group {
            if Application.isTakingSnapshot {
                EmptyView()
            } else {
                AppGroupBox("Developer Functions") {
                    Note(icon: Image.developer.foregroundColor(.red), content: content)
                        .accessibility(label: Text("Debug"))
                }
            }
        }
    }
}

public struct Info: View {
    let text: Text
    
    public init(_ text: Text) {
        self.text = text
    }
    
    public init(_ string: String) {
        self.init(Text(string))
    }

    public var body: some View {
        Note(icon: Image.info.foregroundColor(.blue), content: text)
            .accessibility(label: text)
    }
}

public struct Caution: View {
    let text: Text

    public init(_ text: Text) {
        self.text = text
    }
    
    public init(_ string: String) {
        self.init(Text(string))
    }

    public var body: some View {
        Note(icon: Image.warning.foregroundColor(.yellowLightSafe), content: text)
            .accessibility(label: text)
    }
}

public struct Failure: View {
    let text: Text

    public init(_ text: Text) {
        self.text = text
    }
    
    public init(_ string: String) {
        self.init(Text(string))
    }

    public var body: some View {
        Note(icon: Image.failure.foregroundColor(.red), content: text)
            .accessibility(label: text)
    }
}

public struct Success: View {
    let text: Text

    init(_ text: Text) {
        self.text = text
    }
    
    public init(_ string: String) {
        self.init(Text(string))
    }

    public var body: some View {
        Note(icon: Image.success.foregroundColor(.green), content: text)
            .accessibility(label: text)
    }
}

#if DEBUG

import WolfLorem

struct Note_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            Info(Lorem.sentences(2))
            Caution(Lorem.sentences(2))
                .font(.caption)
            Success(Lorem.sentences(2))
            Failure(Lorem.sentences(2))
            DeveloperFunctions {
                Text(Lorem.sentences(2))
            }
        }
        .padding()
    }
}

#endif
