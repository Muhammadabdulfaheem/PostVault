import Foundation
import RxSwift

protocol SessionRepository: AnyObject {
    var isLoggedIn: Bool { get }
    var currentAccountKey: String? { get }
    func login(email: String, password: String) -> Completable
    func logout()
}

