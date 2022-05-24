import Foundation

public extension String {
    func convertNonwordToSpace() -> String {
        String(map { $0.isLetter ? $0 : " " })
    }
}
