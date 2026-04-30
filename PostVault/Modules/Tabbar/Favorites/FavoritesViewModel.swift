import Foundation
import RxRelay
import RxSwift

final class FavoritesViewModel {


    let items = BehaviorRelay<[PostData]>(value: [])
    let removedToast = PublishSubject<Void>()
    let error = PublishSubject<String>()


    private let postRepository: PostRepository
    private let bag = DisposeBag()

    init(postRepository: PostRepository = AppServices.postRepository) {
        self.postRepository = postRepository
    }


    func initialize() {
        observeRealm()
    }

    private func observeRealm() {
        postRepository.observeFavoritePosts()
            .map { list in
                list.map { PostData(id: $0.id, title: $0.title, subtitle: $0.body, isFavorite: $0.isFavorite) }
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] rows in
                self?.items.accept(rows)
            })
            .disposed(by: bag)
    }

    func removeFavorite(postId: Int) {
        postRepository.removeFromFavorites(postId: postId)
            .subscribe(
                onCompleted: { [weak self] in self?.removedToast.onNext(()) },
                onError: { [weak self] err in
                    self?.error.onNext(
                        UserFacingErrorText.message(
                            from: err,
                            fallback: "Couldn't update favorites. Please try again."
                        )
                    )
                }
            )
            .disposed(by: bag)
    }
}
