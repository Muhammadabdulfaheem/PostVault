import Foundation
import Realm
import RealmSwift
import RxSwift

final class RealmPostRepository: PostRepository {
    private let realmProvider: RealmProvider
    private let sessionRepository: SessionRepository

    private static let realmWriteScheduler = SerialDispatchQueueScheduler(
        internalSerialQueueName: "com.postvault.RealmPostRepository.write"
    )

    private static let importPostsQueue = DispatchQueue(label: "com.postvault.posts.import", qos: .userInitiated)

    init(realmProvider: RealmProvider, sessionRepository: SessionRepository) {
        self.realmProvider = realmProvider
        self.sessionRepository = sessionRepository
    }

    func hasCachedPosts() -> Bool {
        guard let realm = try? realmProvider.realm() else { return false }
        return !realm.objects(PostObject.self).isEmpty
    }

    func savePostsFromAPI(_ dtos: [PostDTO]) -> Completable {
        Completable.create { [weak self] completable in
            guard let self else {
                completable(
                    .error(
                        NSError(
                            domain: "PostVault",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Repository deallocated"]
                        )
                    )
                )
                return Disposables.create()
            }
            Self.importPostsQueue.async {
                do {
                    let realm = try self.realmProvider.realm()
                    try realm.write {
                        for dto in dtos {
                            let object = PostObject(
                                id: dto.id,
                                userId: dto.userId,
                                title: dto.title,
                                body: dto.body,
                                isFavorite: false
                            )
                            realm.add(object, update: .modified)
                        }
                    }
                    completable(.completed)
                } catch {
                    completable(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    func observePosts() -> Observable<[Post]> {
        postsWithPerAccountFavorites()
    }

    func observeFavoritePosts() -> Observable<[Post]> {
        postsWithPerAccountFavorites()
            .map { $0.filter(\.isFavorite) }
    }

    private func postsWithPerAccountFavorites() -> Observable<[Post]> {
        Observable.create { [weak self] observer in
            guard let self else {
                observer.onCompleted()
                return Disposables.create()
            }
            let realm: Realm
            do {
                realm = try self.realmProvider.realm()
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
            let emit: () -> Void = { [weak self] in
                guard let self else { return }
                observer.onNext(self.mapAllPosts(in: realm))
            }
            let tPosts = realm.objects(PostObject.self).observe { _ in emit() }
            let tFav = realm.objects(FavoriteObject.self).observe { _ in emit() }
            let tSession = realm.objects(SessionObject.self).observe { _ in emit() }
            emit()
            return Disposables.create {
                let inv: () -> Void = {
                    tPosts.invalidate()
                    tFav.invalidate()
                    tSession.invalidate()
                }
                if Thread.isMainThread {
                    inv()
                } else {
                    DispatchQueue.main.async(execute: inv)
                }
            }
        }
        .subscribe(on: MainScheduler.instance)
    }


    private func mapAllPosts(in realm: Realm) -> [Post] {
        let key: String?
        if let session = realm.object(ofType: SessionObject.self, forPrimaryKey: "current") {
            key = AccountKey.normalize(session.email)
        } else {
            key = nil
        }
        let favorited: Set<Int>
        if let key {
            let rows = realm.objects(FavoriteObject.self).filter("accountKey == %@", key)
            favorited = Set(rows.map { $0.postId })
        } else {
            favorited = []
        }
        return realm
            .objects(PostObject.self)
            .sorted(byKeyPath: "id", ascending: true)
            .map { o in
                Post(
                    id: o.id,
                    userId: o.userId,
                    title: o.title,
                    body: o.body,
                    isFavorite: favorited.contains(o.id)
                )
            }
    }

    func toggleFavorite(postId: Int) -> Single<Bool> {
        Single.create { [weak self] single in
            guard let self else {
                single(
                    .failure(
                        NSError(
                            domain: "PostVault",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Repository deallocated"]
                        )
                    )
                )
                return Disposables.create()
            }
            guard let accountKey = self.sessionRepository.currentAccountKey else {
                let err = NSError(
                    domain: "PostVault",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Not signed in"]
                )
                single(.failure(err))
                return Disposables.create()
            }
            do {
                let realm = try self.realmProvider.realm()
                let pk = FavoriteObject.makeId(accountKey: accountKey, postId: postId)
                var result = false
                try realm.write {
                    if let existing = realm.object(ofType: FavoriteObject.self, forPrimaryKey: pk) {
                        realm.delete(existing)
                        result = false
                    } else {
                        guard realm.object(ofType: PostObject.self, forPrimaryKey: postId) != nil else {
                            throw NSError(
                                domain: "PostVault",
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey: "Post not found"]
                            )
                        }
                        realm.add(FavoriteObject(accountKey: accountKey, postId: postId), update: .modified)
                        result = true
                    }
                }
                single(.success(result))
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
        .subscribeOn(Self.realmWriteScheduler)
    }

    func removeFromFavorites(postId: Int) -> Completable {
        Completable.create { [weak self] completable in
            guard let self else {
                completable(.completed)
                return Disposables.create()
            }
            guard let accountKey = self.sessionRepository.currentAccountKey else {
                completable(.completed)
                return Disposables.create()
            }
            do {
                let realm = try self.realmProvider.realm()
                let pk = FavoriteObject.makeId(accountKey: accountKey, postId: postId)
                try realm.write {
                    if let f = realm.object(ofType: FavoriteObject.self, forPrimaryKey: pk) {
                        realm.delete(f)
                    }
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
        .subscribe(on: Self.realmWriteScheduler)
    }
}
