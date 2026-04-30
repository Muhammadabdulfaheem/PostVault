import Foundation

final class FormValidator {
    func isValidEmail(_ text: String?) -> Bool {
        Self.isValidEmail((text ?? "").trimmingCharacters(in: .whitespacesAndNewlines))
    }

    func isValidPasswordLength(_ text: String?, min: Int, max: Int) -> Bool {
        let value = (text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return (min...max).contains(value.count)
    }

    func validateText(_ text: String?, rules: [FormError]) throws -> String {
        for rule in rules {
            switch rule {
            case .invalidEmail:
                guard isValidEmail(text) else { throw FormError.invalidEmail }
            case .invalidPasswordLength(let min, let max):
                guard isValidPasswordLength(text, min: min, max: max) else {
                    throw FormError.invalidPasswordLength(min: min, max: max)
                }
            }
        }
        return (text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func isValidEmail(_ value: String) -> Bool {
        guard !value.isEmpty else { return false }
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return value.range(of: pattern, options: .regularExpression) != nil
    }
}

