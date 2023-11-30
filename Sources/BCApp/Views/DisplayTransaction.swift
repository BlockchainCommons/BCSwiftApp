import SwiftUI
import WolfSwiftUI

public struct DisplayTransaction<Prompt>: View where Prompt: View {
    @Binding var isPresented: Bool
    let isSensitive: Bool
    let ur: UR
    let additionalFlowItems: [AnyView]
    let title: String
    let caption: String?
    let fields: ExportFields?
    let prompt: () -> Prompt
    @State private var activityParams: ActivityParams?
    
    public init(isPresented: Binding<Bool>, isSensitive: Bool, ur: UR, title: String, caption: String? = nil, fields: ExportFields? = nil, items: [AnyView] = [], @ViewBuilder prompt: @escaping () -> Prompt) {
        self._isPresented = isPresented
        self.isSensitive = isSensitive
        self.ur = ur
        self.title = title
        self.caption = caption
        self.fields = fields
        self.prompt = prompt
        self.additionalFlowItems = items
    }
    
    public var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                if let caption {
                    Text(caption)
                        .font(.caption)
                }
                ChatBubble(direction: .trailing, fill: Color.accentColor.opacity(0.25), stroke: .accentColor, lineWidth: 3) {
                    VStack(alignment: .trailing, spacing: 20) {
                        prompt()
                        qrCode
                        buttons
                    }
                    .padding(20)
                    .background(ActivityView(params: $activityParams))
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            DoneButton($isPresented)
                        }
                    }
                    .navigationTitle(title)
                    .copyConfirmation()
                }
                Spacer()
            }
            .padding()
        }
    }
    
    var qrCode: some View {
        URDisplay(
            ur: ur,
            name: title,
            fields: fields
        )
        .frame(maxWidth: 300, maxHeight: 300)
    }
    
    var buttons: some View {
        VStack(alignment: .trailing) {
            ExportDataButton("Share as ur:\(ur.type)", icon: Image.ur, isSensitive: isSensitive) {
                activityParams = ActivityParams(
                    ur,
                    name: title,
                    fields: fields
                )
            }
            
            WriteNFCButton(ur: ur, isSensitive: isSensitive, alertMessage: "Write UR for \(title).")
        }
    }
}

#if DEBUG

import WolfLorem

struct DisplayRequest_Previews: PreviewProvider {
    static let seedV1 = Seed()
    
    static var previews: some View {
        DisplayTransaction(
            isPresented: .constant(true), isSensitive: false,
            ur: TransactionRequest(
                body: OutputDescriptorRequestBody(name: Lorem.title(), useInfoV1: .init(), challenge: SecureRandomNumberGenerator.shared.data(count: 16)), note: Lorem.sentence()).ur,
            title: "Descriptor Request",
            caption: Lorem.sentence()
        ) {
            HStack {
                Asset.btc.icon
                Network.mainnet.icon
                Symbol.outputDescriptor
                Image.questionmark
            }
            .font(.title)
        }
        .darkMode()
    }
}

#endif
