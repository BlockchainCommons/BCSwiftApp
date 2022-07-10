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
            try receive(ur: UR(urString: urString))
        } catch {
            resultPublisher.send(.failure(GeneralError("Unrecognized format.")))
        }
    }
    
    func receive(ur: UR) {
        do {
            switch ur.type {
            case "crypto-seed":
                let seed = try Seed(ur: ur)
                resultPublisher.send(.seed(seed))
            case "crypto-request", "crypto-psbt":
                let request = try TransactionRequest(ur: ur)
                resultPublisher.send(.request(request))
            case "crypto-response":
                let response = try TransactionResponse(ur: ur)
                resultPublisher.send(.response(response))
            case "crypto-sskr":
                if
                    let secret = try sskrDecoder.addShare(ur: ur),
                    let seed = Seed(data: secret)
                {
                    resultPublisher.send(.seed(seed))
                }
            default:
                let message = "Unrecognized UR: \(ur.type)"
                resultPublisher.send(.failure(GeneralError(message)))
            }
        } catch {
            resultPublisher.send(.failure(error))
        }
    }
}
