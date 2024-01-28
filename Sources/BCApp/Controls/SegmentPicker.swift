import SwiftUI

public struct SegmentPicker<SegmentType>: View where SegmentType: Segment {
    @Binding var selection: SegmentType? {
        didSet {
            updateSelectionIndex()
        }
    }
    @Binding var segments: [SegmentType]
    
    @State private var selectionIndex: Int?
    @State private var height: CGFloat?
    @State private var segmentWidth: CGFloat?
    
    public init(selection: Binding<SegmentType?>, segments: Binding<[SegmentType]>) {
        self._selection = selection
        self._segments = segments
    }
    
    func updateSelectionIndex() {
        if let selection = selection {
            selectionIndex = segments.firstIndex(of: selection)
        } else {
            selectionIndex = nil
        }
    }
        
    public var body: some View {
        GeometryReader { viewProxy in
            ZStack(alignment: .topLeading) {
                Capsule().fill(Color.formGroupBackground)
                if let selectionIndex = selectionIndex, let segmentWidth = segmentWidth {
                    Capsule()
                        .fill(Color.formGroupBackground)
                        .offset(x: CGFloat(selectionIndex) * segmentWidth)
                        .frame(width: segmentWidth)
                }
                HStack(spacing: 0) {
                    ForEach(segments) { segment in
                        segment.label
                            .padding([.leading, .trailing], 5)
                            .padding(6)
                            .frame(width: segmentWidth)
                            .background(
                                GeometryReader { segmentLabelProxy in
                                    Color.clear
                                        .preference(key: MaxHeightKey.self, value: segmentLabelProxy.size.height)
                                }
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    selection = segment
                                }
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityAddTraits(.isButton)
                            .accessibilityRemoveTraits(.isImage)
                    }
                    .onPreferenceChange(MaxHeightKey.self) { value in
                        height = value
                    }
                }
            }
            .preference(key: SegmentWidthKey.self, value: viewProxy.size.width / CGFloat(segments.count))
            .onPreferenceChange(SegmentWidthKey.self) { value in
                segmentWidth = value
            }
        }
        .onChange(of: segments) {
            selection = segments.first!
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .onAppear {
            updateSelectionIndex()
        }
        .fixedVertical()
    }
}

fileprivate struct MaxHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

fileprivate struct SegmentWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


#if DEBUG

struct SegmentedPickerPreviewView: View {
    @State var selection: BasicSegment?
    
    private let segments: [BasicSegment] = [
        BasicSegment(title: "M", icon: Image.circled("m").foregroundColor(Color.red).eraseToAnyView()),
        BasicSegment(title: "T", icon: Image.circled("t").foregroundColor(Color.orange).eraseToAnyView()),
        BasicSegment(title: "W", icon: Image.circled("w").foregroundColor(Color.yellow).eraseToAnyView()),
        BasicSegment(title: "T", icon: Image.circled("t").foregroundColor(Color.green).eraseToAnyView()),
        BasicSegment(title: "F", icon: Image.circled("f").foregroundColor(Color.blue).eraseToAnyView()),
    ]
    
    var body: some View {
        SegmentPicker(selection: $selection, segments: .constant(segments))
            .padding()
            .onAppear {
                selection = segments[0]
            }
    }
}

struct SegmentedPicker_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedPickerPreviewView()
            .darkMode()
    }
}

#endif
