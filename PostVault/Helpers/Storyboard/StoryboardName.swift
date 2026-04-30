import UIKit


enum StoryboardName: String {
    case login = "Auth"
    case home = "Home"

    enum ID {
        static let loginViewController = "LoginViewController"
        static let postsViewController = "PostsViewController"
        static let favoritesViewController = "FavoritesViewController"
    }

    var storyboard: UIStoryboard {
        UIStoryboard(name: rawValue, bundle: nil)
    }
}
