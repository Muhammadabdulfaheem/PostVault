import UIKit
import RxCocoa
import RxSwift

final class PostsViewController: UIViewController {


    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var loader: UIActivityIndicatorView!


    var onLogout: (() -> Void)?

    private let viewModel = PostsViewModel()
    private let disposeBag = DisposeBag()
    private var didBind = false
    private let cellId = String(describing: PostListTVCell.self)


    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAccessibility()
        setupNavigation()
        setupTableView()
        bindViewModel()
        viewModel.initialize()
    }
}

// MARK: - Setup

private extension PostsViewController {

    func setupAccessibility() {
        tableView.accessibilityIdentifier = TabScreenAccessibility.Posts.table
        loader.accessibilityIdentifier = TabScreenAccessibility.Posts.loader
    }

    func setupNavigation() {
        view.backgroundColor = .systemBackground
        title = "Posts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: nil)
    }

    func setupTableView() {
        tableView.register(UINib(nibName: cellId, bundle: .main), forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }
}



// MARK: - Binding

private extension PostsViewController {

    func bindViewModel() {
        guard !didBind else { return }
        didBind = true
        bindTable()
        bindRowTap()
        bindLoading()
        bindFavoriteToast()
        bindErrors()
        bindLogout()
    }

    func bindTable() {
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: cellId, cellType: PostListTVCell.self)) { _, item, cell in
                cell.selectionStyle = .none
                cell.configurePostingListCell(item)
            }
            .disposed(by: disposeBag)
    }

    func bindRowTap() {
        tableView.rx.modelSelected(PostData.self)
            .subscribe(onNext: { [weak self] item in
                guard let self else { return }
                if let ip = self.tableView.indexPathForSelectedRow {
                    self.tableView.deselectRow(at: ip, animated: true)
                }
                self.viewModel.toggleFavorite(postId: item.id)
            })
            .disposed(by: disposeBag)
    }

    func bindLoading() {
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                guard let self else { return }
                if loading { self.loader.startAnimating() } else { self.loader.stopAnimating() }
                self.tableView.isUserInteractionEnabled = !loading
            })
            .disposed(by: disposeBag)
    }

    func bindFavoriteToast() {
        viewModel.favoriteToast
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                guard let self else { return }
                AppAlert.show(on: self, title: "", message: message)
            })
            .disposed(by: disposeBag)
    }

    func bindErrors() {
        viewModel.loadError
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                guard let self else { return }
                AppAlert.show(on: self, title: "Error", message: message)
            })
            .disposed(by: disposeBag)
    }

    func bindLogout() {
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                AppAlert.showConfirmation(
                    on: self,
                    title: "Log out",
                    message: "Are you sure you want to log out?",
                    onConfirm: { [weak self] in self?.onLogout?() }
                )
            })
            .disposed(by: disposeBag)
    }
}
