import Foundation
final class NetworkAuthTokenStore {
    static let shared = NetworkAuthTokenStore()

    private let lock = NSLock()
    private var _bearerToken: String?

    var bearerToken: String? {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _bearerToken
        }
        set {
            lock.lock()
            _bearerToken = newValue
            lock.unlock()
        }
    }

    private init() {}
}
