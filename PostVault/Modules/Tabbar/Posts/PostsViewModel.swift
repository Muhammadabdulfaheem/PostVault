import Foundation
import RxRelay
import RxSwift

final class PostsViewModel {

    let items = BehaviorRelay<[PostData]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
   
    let loadError = PublishSubject<String>()
    let favoriteToast = PublishSubject<String>()

    private let postRepository: PostRepository
    private let shouldFetchOnInitialize: Bool
    private let bag = DisposeBag()

    init(
        postRepository: PostRepository = AppServices.postRepository,
        shouldFetchOnInitialize: Bool = true
    ) {
        self.postRepository = postRepository
        self.shouldFetchOnInitialize = shouldFetchOnInitialize
    }

    func initialize() {
        observeRealm()
        if shouldFetchOnInitialize {
            fetchFromNetwork()
        }
    }

    private func observeRealm() {
        postRepository.observePosts()
            .map { list in
                list.map { PostData(id: $0.id, title: $0.title, subtitle: $0.body, isFavorite: $0.isFavorite) }
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] rows in
                self?.items.accept(rows)
            })
            .disposed(by: bag)
    }

  
    private func fetchFromNetwork() {
        isLoading.accept(true)
        APIService.fetchPosts()
            .flatMapCompletable { [postRepository] dtos in postRepository.savePostsFromAPI(dtos) }
            .observe(on: MainScheduler.instance)
            .subscribe(
                onCompleted: { [weak self] in
                    self?.isLoading.accept(false)
                },
                onError: { [weak self] err in
                    guard let self else { return }
                    self.isLoading.accept(false)
                    if self.postRepository.hasCachedPosts() {
                        return
                    }
                    self.loadError.onNext(
                        UserFacingErrorText.message(
                            from: err,
                            fallback: "Couldn't load posts. Check your connection and try again."
                        )
                    )
                }
            )
            .disposed(by: bag)
    }

    func toggleFavorite(postId: Int) {
        postRepository.toggleFavorite(postId: postId)
            .subscribe(
                onSuccess: { [weak self] isFavorite in
                    let msg = isFavorite
                        ? "Post added to favorites successfully"
                        : "Post removed from favorites successfully"
                    self?.favoriteToast.onNext(msg)
                },
                onFailure: { [weak self] err in
                    self?.loadError.onNext(
                        UserFacingErrorText.message(
                            from: err,
                            fallback: "Couldn't update favorites. Please try again."
                        )
                    )
                }
            )
            .disposed(by: bag)
    }

    func reloadFromNetwork() {
        fetchFromNetwork()
    }
}
