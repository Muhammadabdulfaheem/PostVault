import Foundation


enum AppServices {

    private static let realmProvider = RealmProvider(configuration: AppRealmConfiguration.default)
    private static let realmSessionRepository = RealmSessionRepository(realmProvider: realmProvider)

    static let sessionRepository: SessionRepository = realmSessionRepository

    static let postRepository: PostRepository = RealmPostRepository(
        realmProvider: realmProvider,
        sessionRepository: realmSessionRepository
    )
}
