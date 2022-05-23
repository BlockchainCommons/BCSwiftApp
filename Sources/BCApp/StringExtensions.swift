import Foundation

extension String {
    public func convertNonwordToSpace() -> String {
        String(map { $0.isLetter ? $0 : " " })
    }
}
