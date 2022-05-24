//
//  FormSectionStyle.swift
//  Gordian Seed Tool
//
//  Created by Wolf McNally on 12/11/20.
//

import SwiftUI

struct FormSectionStyle: ViewModifier {
    let isVisible: Bool

    func body(content: Content) -> some View {
        content
            .padding(isVisible ? 10 : 0)
            .background(isVisible ? Color(UIColor.formGroupBackground) : Color.clear)
            .cornerRadius(isVisible ? 10 : 0)
    }
}

public extension View {
    func formSectionStyle(isVisible: Bool = true) -> some View {
        modifier(FormSectionStyle(isVisible: isVisible))
    }
}

public struct ConditionalGroupBox<Label, Content>: View where Label : View, Content : View {
    let isVisible: Bool
    let label: () -> Label
    let content: () -> Content

    public init(isVisible: Bool = true, @ViewBuilder label: @escaping () -> Label, @ViewBuilder content: @escaping () -> Content) {
        self.isVisible = isVisible
        self.label = label
        self.content = content
    }

    public var body: some View {
        if isVisible {
            return GroupBox(label: label(), content: content).eraseToAnyView()
        } else {
            return content().eraseToAnyView()
        }
    }
}

struct FormGroupBoxTitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content.font(Font.system(.headline).smallCaps())
    }
}

public extension View {
    func formGroupBoxTitleFont() -> some View {
        modifier(FormGroupBoxTitleFont())
    }
}

struct FormGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label.formGroupBoxTitleFont()
            configuration.content
                .formSectionStyle()
        }
    }
}

public extension View {
    func formGroupBoxStyle() -> some View {
        groupBoxStyle(FormGroupBoxStyle())
    }
}

public struct AppGroupBox<Label, Content>: View where Label: View, Content: View {
    let content: Content
    let label: Label
    
    public init(@ViewBuilder label: () -> Label, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.label = label()
    }
    
    public init(label: Label, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.label = label
    }

    public var body: some View {
        GroupBox(content: {content}, label: {label})
            .formGroupBoxStyle()
    }
}

public extension AppGroupBox where Label == EmptyView {
    init(@ViewBuilder content: () -> Content) {
        self.init(label: {EmptyView()}, content: content)
    }
}

public extension AppGroupBox where Label == Text {
    init<S>(_ title: S, @ViewBuilder content: () -> Content) where S : StringProtocol {
        self.init(label: { Text(title) }, content: content)
    }

    init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.init(label: { Text(titleKey) }, content: content)
    }
}
