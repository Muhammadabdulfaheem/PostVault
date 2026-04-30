import Foundation

enum UserFacingErrorText {
    static func message(from error: Error, fallback: String) -> String {
        let le = error as? LocalizedError
        if let d = le?.errorDescription, !d.isEmpty { return d }
        if let f = le?.failureReason, !f.isEmpty { return f }
        if error.localizedDescription.isEmpty {
            return fallback
        }
        return error.localizedDescription
    }
}
