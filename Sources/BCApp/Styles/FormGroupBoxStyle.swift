import SwiftUI

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
