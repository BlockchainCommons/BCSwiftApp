//
//  File.swift
//  
//
//  Created by Wolf McNally on 5/23/22.
//

import SwiftUI
import UIKit

extension UIImage {
    public static var copy: UIImage { UIImage(systemName: "doc.on.doc")! }
}

extension Image {
    public static var bcLogo: Image { Image("bc-logo", bundle: Bundle.module) }

    // Formats
    public static var ur: Image { Image("ur.bar", bundle: Bundle.module) }
    public static var base58: Image { Image("58.bar", bundle: Bundle.module) }
    public static var sskr: Image { Image("sskr.bar", bundle: Bundle.module) }
    public static var bip39: Image { Image("39.bar", bundle: Bundle.module) }
    public static var byteWords: Image { Image("bytewords.bar", bundle: Bundle.module) }
    public static var hex: Image { Image("hex.bar", bundle: Bundle.module) }
    public static var secure: Image { Image(systemName: "shield.lefthalf.fill") }

    // Actions
    public static var nfc: Image { Image("nfc", bundle: Bundle.module) }
    public static var settings: Image { Image(systemName: "gearshape") }

    public static func operation(success: Bool) -> Image {
        success ? self.success : self.failure
    }

    public static var add: Image { Image(systemName: "plus") }
    public static var export: Image { Image(systemName: "square.and.arrow.up.on.square") }
    public static var share: Image { Image(systemName: "square.and.arrow.up") }
    public static var copy: Image { Image(systemName: "doc.on.doc") }
    public static var confirmCopy: Image { Image(systemName: "doc.on.doc.fill") }
    public static var paste: Image { Image(systemName: "doc.on.clipboard") }
    public static var clear: Image { Image(systemName: "clear") }
    public static var clearField: Image { Image(systemName: "multiply.circle.fill") }
    public static var deletePrevious: Image { Image(systemName: "delete.left") }
    public static var menu: Image { Image(systemName: "ellipsis.circle") }
    public static var randomize: Image { Image(systemName: "die.face.5.fill") }
    public static var backup: Image { Image(systemName: "archivebox") }
    public static var scan: Image { Image(systemName: "qrcode.viewfinder") }
    public static var displayQRCode: Image { Image(systemName: "qrcode" ) }
    public static var print: Image { Image(systemName: "printer") }
    public static var files: Image { Image(systemName: "doc") }
    public static var photos: Image { Image(systemName: "photo") }
    public static var developer: Image { Image(systemName: "ladybug.fill") }
    public static var guide: Image { Image(systemName: "info.circle") }
    
    public static var camera: Image { Image(systemName: "camera.circle")}
    public static var frontCamera: Image { Image(systemName: "arrow.triangle.2.circlepath.circle.fill")}
    public static var backCamera: Image { Image(systemName: "arrow.triangle.2.circlepath.circle")}
    
    public static func iCloud(on: Bool) -> Image {
        Image(systemName: on ? "icloud" : "xmark.icloud")
    }
    
    public static var info: Image { Image(systemName: "info.circle.fill") }
    public static var warning: Image { Image(systemName: "exclamationmark.triangle.fill") }
    public static var success: Image { Image(systemName: "checkmark.circle.fill") }
    public static var failure: Image { Image(systemName: "xmark.octagon.fill") }
    
    public static var reveal: Image { Image(systemName: "eye") }
    public static var hide: Image { Image(systemName: "eye.slash") }
    
    public static func toggleVisibility(isRevealed: Bool) -> Image {
        isRevealed ? hide : reveal
    }

    public static var locked: Image { Image(systemName: "lock.fill") }
    public static var unlocked: Image { Image(systemName: "lock.open.fill") }
    
    public static func toggleUnlocked(isRevealed: Bool) -> Image {
        isRevealed ? unlocked : locked
    }
    
    public enum Direction {
        case previous
        case next
    }
    
    public static func navigation(_ direction: Direction) -> Image {
        switch direction {
        case .previous:
            return Image(systemName: "arrowtriangle.left.fill")
        case .next:
            return Image(systemName: "arrowtriangle.right.fill")
        }
    }

    // Objects
    public static var seed: Image { Image("seed.circle", bundle: Bundle.module) }
    public static var key: Image { Image("key.fill.circle", bundle: Bundle.module) }
    public static var privateKey: Image { Image("key.prv.circle", bundle: Bundle.module) }
    public static var publicKey: Image { Image("key.pub.circle", bundle: Bundle.module) }
    public static var address: Image { Image(systemName: "envelope.circle") }
    public static var outputDescriptor: Image { Image(systemName: "rhombus") }
    public static var outputBundle: Image { Image(systemName: "square.stack.3d.up") }
    public static var missing: Image { Image(systemName: "questionmark.circle") }

    // Fields
    public static var name: Image { Image(systemName: "quote.bubble") }
    public static var date: Image { Image(systemName: "calendar") }
    public static var note: Image { Image(systemName: "note.text") }

    // Assets
    public static var bitcoin: Image { Image("asset.btc", bundle: Bundle.module) }
    public static var ethereum: Image { Image("asset.eth", bundle: Bundle.module) }
    public static var bitcoinCash: Image { Image("asset.bch", bundle: Bundle.module) }
    public static var ethereumClassic: Image { Image("asset.etc", bundle: Bundle.module) }
    public static var litecoin: Image { Image("asset.ltc", bundle: Bundle.module) }
    
    // Networks
    public static var mainnet: Image { Image("network.main", bundle: Bundle.module) }
    public static var testnet: Image { Image("network.test", bundle: Bundle.module) }
    public static var segwit: Image { Image("segwit", bundle: Bundle.module) }
    
    // UI
    public static var flowDown: Image { Image(systemName: "arrowtriangle.down.fill") }
    
    // Transactions
    public static var txSent: Image { Image(systemName: "arrow.right") }
    public static var txChange: Image { Image(systemName: "arrow.uturn.left") }
    public static var txInput: Image { Image(systemName: "arrow.down") }
    public static var txFee: Image { Image(systemName: "lock.circle") }
    public static var signature: Image { Image(systemName: "signature") }
    public static var signatureNeeded: Image { Image(systemName: "ellipsis.circle") }
    
    // Misc
    public static func circled(_ s: String) -> Image { Image(systemName: "\(s).circle") }
}
