import SwiftUI
import NFC
import os
import BCFoundation

fileprivate let logger = Logger(subsystem: Application.bundleIdentifier, category: "WriteNFCButton")

public struct WriteNFCButton: View, Identifiable {
    public let id: UUID
    let uri: URL
    let isSensitive: Bool
    let alertMessage: String?
    static let nfcReader = NFCReader()
    
    public init(uri: URL, isSensitive: Bool, alertMessage: String?) {
        self.id = UUID()
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
                    try await Self.nfcReader.beginSession(alertMessage: alertMessage)
                } catch {
                    logger.error("⛔️ \(error.localizedDescription)")
                }
            }
        }
        .disabled(!NFCReader.isReadingAvailable)
        .onReceive(Self.nfcReader.tagPublisher) { tag in
            Task {
                do {
                    try await Self.nfcReader.writeURI(tag, uri: uri)
                    Self.nfcReader.invalidate()
                } catch {
                    logger.error("⛔️ \(error.localizedDescription)")
                    Self.nfcReader.invalidate(errorMessage: error.localizedDescription)
                }
            }
        }
    }
}
