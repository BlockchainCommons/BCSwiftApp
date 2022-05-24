import SwiftUI

public struct Symbol: View {
    public let icon: Image
    public let renderingMode: SymbolRenderingMode
    public let color: Color
    
    public var body: some View {
        icon
            .symbolRenderingMode(renderingMode)
            .foregroundStyle(color)
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
}
