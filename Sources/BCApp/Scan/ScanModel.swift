import SwiftUI
import Combine

final class ScanModel: ObservableObject {
    let resultPublisher = PassthroughSubject<ScanResult, Never>()
    var sskrDecoder: SSKRDecoder
    
    init(sskrDecoder: SSKRDecoder) {
        self.sskrDecoder = sskrDecoder
    }
    
    func receive(urString: String) {
        do {
            try receive(ur: UR(urString: urString.trim()))
        } catch {
            resultPublisher.send(.failure(GeneralError("Unrecognized format.")))
        }
    }
    func receive(ur: UR) {
        do {
            switch ur.type {
            case "envelope":
                guard let envelope = try? Envelope(ur: ur) else {
                    let message = "Invalid envelope encoding"
                    resultPublisher.send(.failure(GeneralError(message)))
                    return
                }
                
                if let request = try? TransactionRequest(envelope: envelope) {
                    resultPublisher.send(.request(request))
                } else if let response = try? TransactionResponse(envelope: envelope) {
                    resultPublisher.send(.response(response))
                } else if let seed = try? Seed(envelope: envelope) {
                    resultPublisher.send(.seed(seed))
                } else if let sskrShare = try? envelope.extractObject(SSKRShare.self, forPredicate: .sskrShare) {
                    if let secret = try sskrDecoder.addShare(sskrShare) {
                        guard let contentKey = SymmetricKey(secret) else {
                            throw GeneralError("Invalid content key")
                        }
                        let decrypted = try envelope.decryptSubject(with: contentKey).unwrap()
                        let seed = try Seed(envelope: decrypted)
                        resultPublisher.send(.seed(seed))
                    }
                } else {
                    let message = "Unrecognized envelope contents"
                    resultPublisher.send(.failure(GeneralError(message)))
                }
            case "seed", "crypto-seed":
                let seed = try Seed(ur: ur)
                resultPublisher.send(.seed(seed))
            case "psbt", "crypto-psbt":
                let request = try TransactionRequest(ur: ur)
                resultPublisher.send(.request(request))
            case "sskr", "crypto-sskr":
                if
                    let secret = try sskrDecoder.addShare(ur: ur),
                    let seed = Seed(data: secret)
                {
                    resultPublisher.send(.seed(seed))
                }
            default:
                let message = "Unrecognized ur:\(ur.type)"
                resultPublisher.send(.failure(GeneralError(message)))
            }
        } catch {
            resultPublisher.send(.failure(error))
        }
    }
}
