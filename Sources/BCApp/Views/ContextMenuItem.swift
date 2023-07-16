import SwiftUI

public struct ContextMenuItem: View {
    let title: Text
    let image: Image
    let action: () -> Void
    let key: KeyEquivalent?

    public init(title: Text, image: Image, key: KeyEquivalent? = nil, action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.key = key
        self.action = action
    }

    public init(title: String, image: Image, key: KeyEquivalent? = nil, action: @escaping () -> Void) {
        self.init(title: Text(title), image: image, action: action)
    }

    public var body: some View {
        let button = Button(action: action) {
            MenuLabel(title, icon: image)
        }

        if let key = key {
            button
                .keyboardShortcut(KeyboardShortcut(key, modifiers: [.command]))
        } else {
            button
        }
    }
}

public struct ShareMenuItem: View {
    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        ContextMenuItem(title: "Share", image: Image.share, key: "s", action: action)
    }
}

public struct CopyMenuItem: View {
    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        ContextMenuItem(title: "Copy", image: Image.copy, key: "c", action: action)
    }
}

public struct PasteMenuItem: View {
    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        ContextMenuItem(title: "Paste", image: Image.paste, key: "v", action: action)
    }
}

public struct ClearMenuItem: View {
    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        ContextMenuItem(title: "Clear", image: Image.clear, action: action)
    }
}

public struct RandomizeMenuItem: View {
    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        ContextMenuItem(title: "Randomize", image: Image.randomize, action: action)
    }
}
