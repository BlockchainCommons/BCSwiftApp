import SwiftUI
import LifeHash
import WolfSwiftUI
import BCFoundation

fileprivate struct OfferedSizeKey: PreferenceKey {
    static var defaultValue: CGSize?

    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
    }
}

public struct ObjectIdentityBlock<T: ObjectIdentifiable>: View {
    @Binding var model: T?
    private let allowLongPressCopy: Bool
    private let visualHashWeight: CGFloat
    private let suppressName: Bool
    @State private var activityParams: ActivityParams?
    
    @StateObject private var lifeHashState: LifeHashState
    @StateObject private var lifeHashNameGenerator: LifeHashNameGenerator
    
    @StateObject private var detailLifeHashState: LifeHashState

    @State private var chosenSize: CGSize?
    
    private var actualWidth: CGFloat? {
        guard let chosenSize = chosenSize else { return nil }
        return chosenSize.width
    }

    private var actualHeight: CGFloat? {
        guard let chosenSize = chosenSize else { return nil }
        return max(64, min(chosenSize.width * visualHashWeight, chosenSize.height))
    }

    private var iconSize: CGFloat? {
        guard let actualHeight = actualHeight else { return nil }
        return actualHeight * 0.3
    }
    
    private var hStackSpacing: CGFloat? {
        guard let actualHeight = actualHeight else { return nil }
        return actualHeight * 0.02
    }

    public init(model: Binding<T?>, provideSuggestedName: Bool = false, allowLongPressCopy: Bool = true, generateVisualHashAsync: Bool = true, visualHashWeight: CGFloat = 0.3, suppressName: Bool = false) {
        self._model = model
        self.allowLongPressCopy = allowLongPressCopy
        self.visualHashWeight = visualHashWeight
        self.suppressName = suppressName

        let lifeHashState = LifeHashState(version: .version2, generateAsync: generateVisualHashAsync, moduleSize: generateVisualHashAsync ? 1 : 8)
        _lifeHashState = .init(wrappedValue: lifeHashState)
        _lifeHashNameGenerator = .init(wrappedValue: LifeHashNameGenerator(lifeHashState: provideSuggestedName ? lifeHashState : nil))

        let detailLifeHashState = LifeHashState(version: .version2, generateAsync: generateVisualHashAsync, moduleSize: generateVisualHashAsync ? 1 : 8)
        _detailLifeHashState = .init(wrappedValue: detailLifeHashState)
    }

    public var body: some View {
        return GeometryReader { proxy in
            HStack(alignment: .top) {
                switch model?.visualHashType {
                case .blockies:
                    BlockiesView(seed: model!.fingerprintData)
                default:
                    lifeHashView
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        icon
                        identifier
                    }
                    instanceDetail
                    Spacer()
                    if !suppressName {
                        objectName
                            .layoutPriority(1)
                    }
                }
                
                Spacer()
            }
            .preference(key: OfferedSizeKey.self, value: proxy.size)
        }
        .frame(height: actualHeight)
        .onPreferenceChange(OfferedSizeKey.self) { offeredSize in
            if let chosenSize = chosenSize, let offeredSize = offeredSize {
                self.chosenSize = CGSize(width: max(chosenSize.width, offeredSize.width), height: max(chosenSize.height, offeredSize.height))
            } else {
                chosenSize = offeredSize
            }
        }
        .onAppear {
            lifeHashState.fingerprint = model?.fingerprint
            detailLifeHashState.fingerprint = model?.instanceDetailFingerprintable?.fingerprint
        }
        .onReceive(lifeHashNameGenerator.$suggestedName) { suggestedName in
            guard let suggestedName = suggestedName else { return }
            model?.name = suggestedName
        }
        .onChange(of: model) { newModel in
            lifeHashState.fingerprint = newModel?.fingerprint
            detailLifeHashState.fingerprint = newModel?.instanceDetailFingerprintable?.fingerprint
        }
        .background(ActivityView(params: $activityParams))
    }
    
    @ViewBuilder
    var icon: some View {
        if let model = model {
            HStack(spacing: hStackSpacing) {
                ModelObjectTypeIcon(type: model.modelObjectType)
                    .frame(width: iconSize, height: iconSize)
                    .accessibility(label: Text(model.modelObjectType.name))
                ForEach(model.subtypes) {
                    $0.icon
                }
            }
        } else {
            Image.missing
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
        }
    }
    
    var lifeHashView: some View {
        var fields = model!.exportFields
        fields[.placeholder] = "Lifehash of \(name)"
        fields[.fragment] = "Lifehash"
        fields[.format] = nil

        return LifeHashView(state: lifeHashState) {
            Rectangle()
                .fill(Color.gray)
        }
        .accessibility(label: Text("LifeHash"))
        .conditionalLongPressAction(actionEnabled: allowLongPressCopy) {
            if let image = lifeHashState.osImage {
                activityParams = ActivityParams(
                    image.scaled(by: 8),
                    name: name,
                    fields: fields
                )
            }
        }
    }

    @ViewBuilder
    var instanceDetail: some View {
        HStack {
            if model?.instanceDetailFingerprintable != nil {
                LifeHashView(state: detailLifeHashState) {
                    Rectangle()
                        .fill(Color.gray)
                }
                .frame(width: 24, height: 24)
            }

            if let model = model, let instanceDetail = model.instanceDetail {
                Text(instanceDetail)
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .fixedVertical()
                    .conditionalLongPressAction(actionEnabled: allowLongPressCopy) {
                        activityParams = ActivityParams(
                            instanceDetail,
                            name: name,
                            fields: fields
                        )
                    }
            } else {
                EmptyView()
            }
        }
    }
    
    private var fields: ExportFields {
        var fields = model!.exportFields
        fields[.placeholder] = "Detail of \(name)"
        fields[.fragment] = "Detail"
        fields[.format] = nil
        return fields
    }
    
    var identifier: some View {
        let digest = model?.fingerprint.digest.hex ?? "?"
        
        var fields = model!.exportFields
        fields[.placeholder] = "Identifier of \(name)"
        fields[.fragment] = "Identifier"
        fields[.format] = "Hex"
        
        return Text(digestIdentifier)
            .appMonospaced()
            .bold()
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .contentShape(Rectangle())
            .conditionalLongPressAction(actionEnabled: allowLongPressCopy) {
                activityParams = ActivityParams(
                    digest,
                    name: name,
                    fields: fields
                )
            }
    }

    var objectName: some View {
        var fields = model!.exportFields
        fields[.placeholder] = "Name of \(name)"
        fields[.fragment] = "Name"
        fields[.format] = nil

        return Text("\(name)")
            .bold()
            .font(.largeTitle)
            .truncationMode(.middle)
            .minimumScaleFactor(0.4)
            .conditionalLongPressAction(actionEnabled: allowLongPressCopy) {
                activityParams = ActivityParams(
                    name,
                    name: name,
                    fields: fields
                )
            }
    }
    
    var digestIdentifier: String {
        model?.digestIdentifier ?? "?"
    }
    
    var name: String {
        model?.name ?? "?"
    }
    
    var type: String {
        model?.modelObjectType.type ?? "?"
    }
}

//final class StubModelObject: ModelObject {
//    let id: UUID
//    let fingerprint: Fingerprint
//    let modelObjectType: ModelObjectType
//    var name: String
//
//    init(id: UUID, fingerprint: Fingerprint, modelObjectType: ModelObjectType, name: String) {
//        self.id = id
//        self.fingerprint = fingerprint
//        self.modelObjectType = modelObjectType
//        self.name = name
//    }
//
//    convenience init<T: ModelObject>(modelObject: T) {
//        self.init(id: modelObject.id, fingerprint: modelObject.fingerprint, modelObjectType: modelObject.modelObjectType, name: modelObject.name)
//    }
//
//    static func ==(lhs: StubModelObject, rhs: StubModelObject) -> Bool {
//        lhs.id == rhs.id
//    }
//
//    var fingerprintData: Data {
//        fatalError()
//    }
//
//    var ur: UR {
//        fatalError()
//    }
//
//    var sizeLimitedUR: (UR, Bool) {
//        fatalError()
//    }
//
//    var visualHashType: VisualHashType {
//        .lifeHash
//    }
//}
//
//#if DEBUG
//
//import WolfLorem
//
//struct ModelObjectIdentity_Previews: PreviewProvider {
//    static let seed: ModelSeed = {
//        let seed = Lorem.seed()
//        seed.name = Lorem.sentence()
//        return seed
//    }()
//    static let seedStub = StubModelObject(modelObject: seed)
//    static let privateHDKey = try! ModelHDKey(seed: seed)
//    static var previews: some View {
//        Group {
//            ObjectIdentityBlock(model: .constant(seed))
//                .previewLayout(.fixed(width: 700, height: 300))
//            ObjectIdentityBlock(model: .constant(seed))
//                .previewLayout(.fixed(width: 300, height: 100))
//            ObjectIdentityBlock(model: .constant(seed))
//                .previewLayout(.fixed(width: 300, height: 300))
//            ObjectIdentityBlock(model: .constant(seedStub))
//                .previewLayout(.fixed(width: 700, height: 300))
//            ObjectIdentityBlock<ModelSeed>(model: .constant(nil))
//                .previewLayout(.fixed(width: 700, height: 300))
//            ObjectIdentityBlock(model: .constant(privateHDKey))
//                .previewLayout(.fixed(width: 300, height: 100))
//            ObjectIdentityBlock(model: .constant(privateHDKey))
//                .previewLayout(.fixed(width: 700, height: 300))
//            List {
//                ObjectIdentityBlock(model: .constant(seed))
//                    .frame(height: 64)
//                ObjectIdentityBlock(model: .constant(seed))
//                    .frame(height: 64)
//                ObjectIdentityBlock(model: .constant(seed))
//                    .frame(height: 64)
//            }
//        }
//        .darkMode()
//        .padding()
//        .border(Color.yellowLightSafe, width: 1)
//    }
//}
//
//#endif
