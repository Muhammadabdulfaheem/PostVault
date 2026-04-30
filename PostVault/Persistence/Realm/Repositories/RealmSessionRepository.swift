import Foundation
import RealmSwift
import RxSwift

enum RealmSessionError: Error {
    case missingProvider
}

final class RealmSessionRepository: SessionRepository {
    private let realmProvider: RealmProvider

    init(realmProvider: RealmProvider) {
        self.realmProvider = realmProvider
    }

    var isLoggedIn: Bool {
        (try? realmProvider.realm().object(ofType: SessionObject.self, forPrimaryKey: "current")) != nil
    }

    var currentAccountKey: String? {
        guard
            let session = try? realmProvider.realm().object(ofType: SessionObject.self, forPrimaryKey: "current")
        else {
            return nil
        }
        return AccountKey.normalize(session.email)
    }

    func login(email: String, password: String) -> Completable {
        Completable.create { [weak self] observer in
            guard let self else {
                observer(.error(RealmSessionError.missingProvider))
                return Disposables.create()
            }
            // Password is required for a real network login; it is not persisted in Realm.
            _ = password
            do {
                let realm = try self.realmProvider.realm()
                try realm.write {
                    realm.add(SessionObject(email: email), update: .modified)
                }
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }

    func logout() {
        do {
            let realm = try realmProvider.realm()
            guard let session = realm.object(ofType: SessionObject.self, forPrimaryKey: "current") else { return }
            try realm.write {
                realm.delete(session)
            }
        } catch {
          
        }
    }
}

