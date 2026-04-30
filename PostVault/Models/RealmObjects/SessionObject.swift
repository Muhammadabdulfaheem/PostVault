import Foundation
import RealmSwift

final class SessionObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var email: String
    @Persisted var createdAt: Date

    convenience init(email: String) {
        self.init()
        self.id = "current"
        self.email = email
        self.createdAt = Date()
    }
}

