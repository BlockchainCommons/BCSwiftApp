import Foundation

public enum ScanResult {
    case seed(Seed)
    case request(TransactionRequest)
    case response(TransactionResponse)
    case failure(Error)
}
