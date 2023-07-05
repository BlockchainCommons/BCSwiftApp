import SwiftUI
import Foundation
import WolfBase

public struct ListPicker<SegmentType>: View where SegmentType: Segment {
    @Binding var selection: SegmentType
    @Binding var segments: [SegmentType]
    
    var selectionIndex: Int? {
        return segments.firstIndex(of: selection)
    }
    
    @State private var width: CGFloat?
    @State private var height: CGFloat?
    @State private var segmentRects =  SegmentRects()
    
    let margin: CGFloat = 10
    
    private func rect(for index: Int) -> CGRect {
        segmentRects.rect(at: index)!
    }
    
    private struct IndexedSegment: Identifiable {
        let index: Int
        let segment: SegmentType
        
        var id: SegmentType.ID {
            segment.id
        }
    }
    
    public init(selection: Binding<SegmentType>, segments: Binding<[SegmentType]>) {
        //print("💙 ListPicker.init")
        self._selection = selection
        self._segments = segments
    }
    
    func height(forSegmentIndex index: Int) -> CGFloat? {
        segmentRects.rect(at: index)?.height
    }
    
    private func measureLabel(geometry: GeometryProxy, segment: IndexedSegment) -> some View {
        let value = SegmentRects(index: segment.index, rect: geometry.frame(in: .named("ListPicker")))
        //print("❤️ preference value: \(value)")
        return Color.clear
            .preference(key: SegmentRectsKey.self, value: value)
    }
    
    private func makeTapBox(geometry: GeometryProxy, index: Int) -> some View {
        let rect = segmentRects.rect(at: index)!
        return Rectangle()
            .fill(Color.clear)
            //.debugYellow()
            .contentShape(Rectangle())
            .frame(width: geometry.size.width, height: rect.size.height)
            .offset(x: rect.minX, y: rect.minY)
            .onTapGesture {
                withAnimation {
                    selection = segments[index]
                }
            }
    }

    public var body: some View {
        let indexedSegments: [IndexedSegment] = segments.enumerated().map { elem in
            IndexedSegment(index: elem.0, segment: elem.1)
        }
        return GeometryReader { viewProxy in
            ZStack(alignment: .topLeading) {
                if
                    let selectionIndex = selectionIndex,
                    let rect = segmentRects.rect(at: selectionIndex)
                {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.formGroupBackground)
                        .frame(width: viewProxy.size.width, height: rect.height)
                        .offset(x: 0, y: rect.minY)
//                        .frame(width: viewProxy.size.width + 2 * margin, height: rect.size.height + 2 * margin)
//                        .offset(x: -margin, y: rect.minY - margin)
                }
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(indexedSegments) { indexedSegment in
                        indexedSegment.segment.label
                            .padding(margin)
//                            .debugBlue()
                            .background(
                                GeometryReader { segmentLabelGeometry in
                                    measureLabel(geometry: segmentLabelGeometry, segment: indexedSegment)
                                }
                            )
//                            .frame(height: height(forSegmentIndex: indexedSegment.index))
                    }
//                    .offset(x: -margin)
                }
                .coordinateSpace(name: "ListPicker")
                
                ForEach(segmentRects.keys, id: \.self) { index in
                    makeTapBox(geometry: viewProxy, index: index)
                }
//                .coordinateSpace(name: "ListPicker")
            }
            .background(
                GeometryReader { viewProxy in
                    Color.clear
                        .preference(key: WidthKey.self, value: viewProxy.size.width)
                }
            )
//            .coordinateSpace(name: "ListPicker")
            .onPreferenceChange(SegmentRectsKey.self) { value in
                segmentRects = value
                let minTop = segmentRects.minTop
                let maxBottom = segmentRects.maxBottom
                //let prevHeight = height
                height = maxBottom - minTop //+ 2 * margin
                //print("💚 onPreferenceChange value: \(value), prevHeight: \(prevHeight†), height: \(height†)")
            }
            .onPreferenceChange(WidthKey.self) { value in
                width = value
            }
//            .padding([.top], margin)
        }
//        .debugRed()
        .frame(width: width, height: height)
    }
}

fileprivate struct WidthKey: PreferenceKey {
    static var defaultValue: CGFloat?
    
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = nextValue()
    }
}

private struct SegmentRects: CustomStringConvertible, Equatable {
    private var dict: [Int: CGRect] = [:]
    
    init() { }
    
    init(index: Int, rect: CGRect) {
        self.dict = [index: rect]
    }
    
    func rect(at index: Int) -> CGRect? {
        dict[index]
    }
    
    var keys: [Int] {
        dict.keys.sorted()
    }
    
    mutating func merge(_ next: SegmentRects) {
        dict.merge(next.dict, uniquingKeysWith: { $1 })
    }
    
    var minTop: CGFloat {
        dict.values.reduce(CGFloat.infinity) { result, rect in
            min(result, rect.minY)
        }
    }
    
    var maxBottom: CGFloat {
        dict.values.reduce(0) { result, rect in
            max(result, rect.maxY)
        }
    }
    
    var description: String {
        let values = dict.keys.sorted().map { index in
            let rect = dict[index]!
            let top = rect.minY
            let height = rect.height
            return "\(index): (top: \(Int(top)), height: \(Int(height)))"
        }
        return values.joined(separator: ", ").flanked("[", "]")
    }
}

fileprivate struct SegmentRectsKey: PreferenceKey {
    static var defaultValue = SegmentRects()

    static func reduce(value: inout SegmentRects, nextValue: () -> SegmentRects) {
        value.merge(nextValue())
        //print("💛 reduce: \(value)")
    }
}

#if DEBUG

import WolfLorem

struct ListPickerPickerPreviewView: View {
    @State var selection: TestSegment = Self.segments[0]
    @State var selection2: TestSegment = Self.segments2[0]

    struct TestSegment: Segment {
        let id = UUID()
        let title: String
        let subtitle: String?
        
        var label: AnyView {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                    .fixedVertical()
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .fixedVertical()
                }
            }
            .eraseToAnyView()
        }
    }
    
    private static let segments: [TestSegment] = [
        TestSegment(title: Lorem.words(10), subtitle: Lorem.sentence()),
        TestSegment(title: Lorem.words(3), subtitle: Lorem.sentence()),
        TestSegment(title: Lorem.words(3), subtitle: Lorem.sentence()),
        TestSegment(title: Lorem.words(3), subtitle: Lorem.sentence()),
        TestSegment(title: Lorem.words(3), subtitle: Lorem.sentence()),
    ]
    
    private static let segments2: [TestSegment] = [
        TestSegment(title: Lorem.words(10), subtitle: Lorem.sentence()),
        TestSegment(title: Lorem.words(3), subtitle: Lorem.sentence()),
        TestSegment(title: Lorem.words(3), subtitle: Lorem.sentence()),
        TestSegment(title: Lorem.words(3), subtitle: Lorem.sentence()),
        TestSegment(title: Lorem.words(3), subtitle: Lorem.sentence()),
    ]

    var body: some View {
        ScrollView {
            VStack {
                ListPicker(selection: $selection, segments: .constant(Self.segments))
                    .padding()
                Button {
                    withAnimation {
                        selection = Self.segments.filter({ $0 != selection }).randomElement()!
                    }
                } label: {
                    Text("Select Random")
                }
//                ListPicker(selection: $selection2, segments: .constant(Self.segments2))
//                    .padding()
            }
        }
    }
}

struct ListPicker_Previews: PreviewProvider {
    static var previews: some View {
        ListPickerPickerPreviewView()
            .darkMode()
    }
}

#endif
