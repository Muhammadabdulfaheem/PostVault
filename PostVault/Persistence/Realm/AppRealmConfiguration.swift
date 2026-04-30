import Foundation
import RealmSwift
import Realm

enum AppRealmConfiguration {
    private static let schemaVersion: UInt64 = 1

    static var `default`: Realm.Configuration {
        var config = Realm.Configuration()
        config.schemaVersion = schemaVersion
        config.migrationBlock = { migration, oldSchemaVersion in
            guard oldSchemaVersion < 1 else { return }
            var migratedAccountKey: String?
            migration.enumerateObjects(ofType: SessionObject.className()) { _, newObject in
                guard let newObject, let email = newObject["email"] as? String else { return }
                migratedAccountKey = AccountKey.normalize(email)
            }
            let accountKey = migratedAccountKey
            migration.enumerateObjects(ofType: PostObject.className()) { oldObject, newObject in
                if let newObject { newObject["isFavorite"] = false }
                guard
                    let oldObject,
                    (oldObject["isFavorite"] as? Bool) == true,
                    let id = oldObject["id"] as? Int
                else { return }
                if let k = accountKey {
                    _ = migration.create(
                        FavoriteObject.className(),
                        value: [
                            "id": FavoriteObject.makeId(accountKey: k, postId: id),
                            "accountKey": k,
                            "postId": id,
                            "createdAt": Date()
                        ]
                    )
                }
            }
        }
        return config
    }
}
