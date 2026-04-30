import Foundation
import RxSwift

protocol PostRepository {
    func savePostsFromAPI(_ dtos: [PostDTO]) -> Completable
    func observePosts() -> Observable<[Post]>
    func observeFavoritePosts() -> Observable<[Post]>
    func toggleFavorite(postId: Int) -> Single<Bool>
    func removeFromFavorites(postId: Int) -> Completable
    func hasCachedPosts() -> Bool
}

