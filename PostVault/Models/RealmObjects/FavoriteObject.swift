import Foundation
import RealmSwift

final class FavoriteObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var accountKey: String
    @Persisted var postId: Int
    @Persisted var createdAt: Date

    static func makeId(accountKey: String, postId: Int) -> String {
        "\(accountKey)|\(postId)"
    }

    convenience init(accountKey: String, postId: Int) {
        self.init()
        self.id = Self.makeId(accountKey: accountKey, postId: postId)
        self.accountKey = accountKey
        self.postId = postId
        self.createdAt = Date()
    }
}
