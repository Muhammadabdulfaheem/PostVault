import Foundation

enum FormError: Error, Equatable {
    case invalidEmail
    case invalidPasswordLength(min: Int, max: Int)
}

