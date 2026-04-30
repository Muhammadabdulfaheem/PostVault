import Foundation


enum AuthPasswordLength {
    static let min = 8
    static let max = 15
}

protocol FormValidating: AnyObject {
    func isValidEmail(_ text: String?) -> Bool
    func isValidPasswordLength(_ text: String?, min: Int, max: Int) -> Bool
}

extension FormValidator: FormValidating {}
