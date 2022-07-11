import SwiftUI

public struct Symbol: View {
    public let icon: Image
    public let renderingMode: SymbolRenderingMode
    public let color: Color
    public let flipsForRightToLeftLayoutDirection: Bool
    
    public init(icon: Image, renderingMode: SymbolRenderingMode, color: Color, flipsForRightToLeftLayoutDirection: Bool = false) {
        self.icon = icon
        self.renderingMode = renderingMode
        self.color = color
        self.flipsForRightToLeftLayoutDirection = flipsForRightToLeftLayoutDirection
    }
    
    public var body: some View {
        icon
            .symbolRenderingMode(renderingMode)
            .foregroundStyle(color)
            .flipsForRightToLeftLayoutDirection(flipsForRightToLeftLayoutDirection)
    }
    
    public static var txSent: Symbol {
        Symbol(icon: .txSent, renderingMode: .monochrome, color: .red)
    }

    public static var txChange: Symbol {
        Symbol(icon: .txChange, renderingMode: .monochrome, color: .green)
    }

    public static var txInput: Symbol {
        Symbol(icon: .txInput, renderingMode: .monochrome, color: .blue)
    }

    public static var txFee: Symbol {
        Symbol(icon: .txFee, renderingMode: .hierarchical, color: .yellowLightSafe)
    }
    
    public static var bitcoin: Symbol {
        Symbol(icon: .bitcoin, renderingMode: .hierarchical, color: .orange)
    }
    
    public static var ethereum: Symbol {
        Symbol(icon: .ethereum, renderingMode: .hierarchical, color: .green)
    }
    
    public static var signature: Symbol {
        Symbol(icon: .signature, renderingMode: .hierarchical, color: .teal)
    }
    
    public static var signatureNeeded: Symbol {
        Symbol(icon: .signatureNeeded, renderingMode: .hierarchical, color: .teal)
    }
    
    public static var outputDescriptor: Symbol {
        Symbol(icon: .outputDescriptor, renderingMode: .monochrome, color: .blue)
    }
    
    public static var sentItem: Symbol {
        Symbol(icon: .sentItem, renderingMode: .monochrome, color: .accentColor)
    }
    
    public static var receivedItem: Symbol {
        Symbol(icon: .receivedItem, renderingMode: .monochrome, color: .secondary)
    }
    
    public static var error: Symbol {
        Symbol(icon: .error, renderingMode: .hierarchical, color: .red)
    }
}
