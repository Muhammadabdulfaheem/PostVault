import UIKit
import RxCocoa
import RxSwift

final class FavoritesViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var emptyStateLabel: UILabel!

  
    var onLogout: (() -> Void)?

    private let viewModel = FavoritesViewModel()
    private let disposeBag = DisposeBag()
    private var didBind = false
    private let cellId = String(describing: PostListTVCell.self)


    override func viewDidLoad() {
        super.viewDidLoad()
        setupAccessibility()
        setupNavigation()
        setupTableView()
        bindViewModel()
        viewModel.initialize()
    }
}


private extension FavoritesViewController {

    func setupAccessibility() {
        tableView.accessibilityIdentifier = TabScreenAccessibility.Favorites.table
        emptyStateLabel.accessibilityIdentifier = TabScreenAccessibility.Favorites.emptyState
    }

    func setupNavigation() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: nil)
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: cellId, bundle: .main), forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }
}

private extension FavoritesViewController {

    func bindViewModel() {
        guard !didBind else { return }
        didBind = true
        bindTable()
        bindEmptyState()
        bindRowTap()
        bindSwipeDelegate()
        bindRemovedToast()
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

    func bindEmptyState() {
        viewModel.items
            .map { !$0.isEmpty }
            .subscribe(onNext: { [weak self] hasRows in
                self?.emptyStateLabel.isHidden = hasRows
            })
            .disposed(by: disposeBag)
    }

    func bindRowTap() {
        tableView.rx.modelSelected(PostData.self)
            .subscribe(onNext: { [weak self] item in
                guard let self else { return }
                if let ip = self.tableView.indexPathForSelectedRow {
                    self.tableView.deselectRow(at: ip, animated: true)
                }
                self.viewModel.removeFavorite(postId: item.id)
            })
            .disposed(by: disposeBag)
    }

    func bindSwipeDelegate() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    func bindRemovedToast() {
        viewModel.removedToast
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                AppAlert.show(on: self, title: "", message: "Post removed from favorites successfully")
            })
            .disposed(by: disposeBag)
    }

    func bindErrors() {
        viewModel.error
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

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < viewModel.items.value.count else { return nil }
        let item = viewModel.items.value[indexPath.row]
        let remove = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _, _, done in
            self?.viewModel.removeFavorite(postId: item.id)
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [remove])
    }
}
