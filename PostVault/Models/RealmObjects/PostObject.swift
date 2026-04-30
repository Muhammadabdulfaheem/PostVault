import Foundation
import RealmSwift

final class PostObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var userId: Int
    @Persisted var title: String
    @Persisted var body: String
    @Persisted var isFavorite: Bool

    convenience init(id: Int, userId: Int, title: String, body: String, isFavorite: Bool) {
        self.init()
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
        self.isFavorite = isFavorite
    }
}

