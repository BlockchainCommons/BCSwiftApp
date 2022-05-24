import SwiftUI
import NFC
import os
import BCFoundation

fileprivate let logger = Logger(subsystem: Application.bundleIdentifier, category: "WriteNFCButton")

public struct WriteNFCButton: View {
    let uri: URL
    let isSensitive: Bool
    let alertMessage: String?
    @StateObject private var nfcReader = NFCReader()
    
    public init(uri: URL, isSensitive: Bool, alertMessage: String?) {
        self.uri = uri
        self.isSensitive = isSensitive
        self.alertMessage = alertMessage
    }
    
    public init(ur: UR, isSensitive: Bool, alertMessage: String?) {
        self.init(uri: URL(string: ur.string)!, isSensitive: isSensitive, alertMessage: alertMessage)
    }

    public var body: some View {
        ExportDataButton("Write NFC Tag", icon: Image.nfc, isSensitive: isSensitive) {
            Task {
                do {
                    try await nfcReader.beginSession(alertMessage: alertMessage)
                } catch {
                    logger.error("⛔️ \(error.localizedDescription)")
                }
            }
        }
        .disabled(!NFCReader.isReadingAvailable)
        .onReceive(nfcReader.tagPublisher) { tag in
            Task {
                do {
                    try await nfcReader.writeURI(tag, uri: uri)
                    nfcReader.invalidate()
                } catch {
                    logger.error("⛔️ \(error.localizedDescription)")
                    nfcReader.invalidate(errorMessage: error.localizedDescription)
                }
            }
        }
    }
}
