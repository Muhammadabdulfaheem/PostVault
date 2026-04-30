import UIKit

final class TabRouter: RouterProtocol {
    var onLogout: (() -> Void)?

    func start() -> UIViewController {
        let home = MainTabBarStoryboard.home
        guard
            let postsVC = home.instantiateViewController(withIdentifier: MainTab.posts.storyboardViewControllerID) as? PostsViewController
        else {
            fatalError(MainTab.posts.missingViewControllerMessage(in: MainTabBarStoryboard.homeName))
        }
        guard
            let favoritesVC = home.instantiateViewController(withIdentifier: MainTab.favorites.storyboardViewControllerID) as? FavoritesViewController
        else {
            fatalError(MainTab.favorites.missingViewControllerMessage(in: MainTabBarStoryboard.homeName))
        }

        let postsNav = UINavigationController(rootViewController: postsVC)
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        let tabBar = MainTabBarController()
        tabBar.setViewControllers([postsNav, favoritesNav], animated: false)
        tabBar.onLogout = { [weak self] in self?.onLogout?() }

        for (nav, tab) in zip([postsNav, favoritesNav], MainTab.allCases) {
            nav.tabBarItem = tab.makeTabBarItem()
        }

        postsVC.onLogout = { [weak self] in self?.onLogout?() }
        favoritesVC.onLogout = { [weak self] in self?.onLogout?() }

        return tabBar
    }
}
