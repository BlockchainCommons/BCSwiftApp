import SwiftUI
import URUI
import WolfSwiftUI
import BCFoundation
import SwiftUIFlowLayout

public struct URExport: View {
    @Binding var isPresented: Bool
    let isSensitive: Bool
    let ur: UR
    let additionalFlowItems: [AnyView]
    let name: String
    let title: String
    let fields: ExportFields?
    @State private var activityParams: ActivityParams?

    public init(isPresented: Binding<Bool>, isSensitive: Bool, ur: UR, name: String, fields: ExportFields? = nil, items: [AnyView] = []) {
        self._isPresented = isPresented
        self.isSensitive = isSensitive
        self.ur = ur
        self.name = name
        var fields = fields ?? [:]
        fields[.format] = "UR"
        self.fields = fields
        self.title = fields[.placeholder] ?? name
        self.additionalFlowItems = items
    }
    
    public var body: some View {
        var flowItems: [AnyView] = []
        flowItems.append(contentsOf: [
            ExportDataButton("Share as `ur:\(ur.type)`", icon: Image.ur, isSensitive: isSensitive) {
                activityParams = ActivityParams(
                    ur,
                    name: name,
                    fields: fields
                )
            }.eraseToAnyView(),
            WriteNFCButton(ur: ur, isSensitive: isSensitive, alertMessage: "Write UR for \(name).").eraseToAnyView()
        ])
        flowItems.append(contentsOf: additionalFlowItems)
        
        return NavigationView {
            VStack {
                Text(title)
                    .font(.subheadline)
                    .bold()
                    .minimumScaleFactor(0.5)
                URDisplay(
                    ur: ur,
                    name: name,
                    fields: fields
                )
#if targetEnvironment(macCatalyst)
                FlowLayout(mode: .vstack, items: flowItems, viewMapping: { $0 })
                    .frame(minHeight: 200)
                    .background(ActivityView(params: $activityParams))
#else
                ScrollView {
                    FlowLayout(mode: .scrollable, items: flowItems) { $0 }
                }
                .frame(minHeight: 200)
                .background(ActivityView(params: $activityParams))
#endif
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    DoneButton($isPresented)
                }
            }
            .navigationTitle("Export")
            .copyConfirmation()
        }
    }
}

#if DEBUG

struct URExport_Previews: PreviewProvider {
    static let seedV1 = Seed()
    
    static var previews: some View {
        try! URExport(
            isPresented: .constant(true),
            isSensitive: true,
            ur: TransactionRequest(
                body: SeedRequestBody(seedDigest: seedV1.identityDigestSource)
            ).ur,
            name: seedV1.name,
            fields: [:]
        )
            .darkMode()
    }
}

#endif
