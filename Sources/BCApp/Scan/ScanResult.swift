import Foundation

public enum ScanResult {
    case seed(Seed)
    case request(TransactionRequest)
    case failure(Error)
}
