import UIKit

/// Shared storyboard, IDs, and tab item appearance for the main (home) `UITabBarController` flow.
enum MainTab: Int, CaseIterable {
    case posts
    case favorites

    var title: String {
        switch self {
        case .posts: return "Posts"
        case .favorites: return "Favorites"
        }
    }

    var systemImageName: String {
        switch self {
        case .posts: return "list.bullet"
        case .favorites: return "star.fill"
        }
    }

    var storyboardViewControllerID: String {
        switch self {
        case .posts: return StoryboardName.ID.postsViewController
        case .favorites: return StoryboardName.ID.favoritesViewController
        }
    }

    func makeTabBarItem() -> UITabBarItem {
        UITabBarItem(
            title: title,
            image: UIImage(systemName: systemImageName),
            selectedImage: nil
        )
    }

    func missingViewControllerMessage(in storyboardName: String) -> String {
        switch self {
        case .posts:
            return
                "\(storyboardName).storyboard: add a scene with class PostsViewController and " +
                "Storyboard ID \"\(storyboardViewControllerID)\"."
        case .favorites:
            return
                "\(storyboardName).storyboard: add a scene with class FavoritesViewController and " +
                "Storyboard ID \"\(storyboardViewControllerID)\"."
        }
    }
}

enum MainTabBarStoryboard {
    static var home: UIStoryboard { StoryboardName.home.storyboard }
    static var homeName: String { StoryboardName.home.rawValue }
}
