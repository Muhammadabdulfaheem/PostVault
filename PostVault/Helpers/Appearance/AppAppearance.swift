import UIKit


enum AppAppearance {
    static func apply() {
        applyNavigationBar()
        applyTabBar()
    }

    private static func applyNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.shadowColor = .clear

        let bar = UINavigationBar.appearance()
        bar.standardAppearance = appearance
        bar.scrollEdgeAppearance = appearance
        bar.compactAppearance = appearance
        if #available(iOS 15.0, *) {
            bar.compactScrollEdgeAppearance = appearance
        }
        bar.tintColor = .black
        bar.isTranslucent = false
    }

    private static func applyTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .separator

        let item = UITabBarItemAppearance()
        item.normal.iconColor = .systemGray
        item.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray]
        item.selected.iconColor = .label
        item.selected.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.stackedLayoutAppearance = item
        appearance.inlineLayoutAppearance = item
        appearance.compactInlineLayoutAppearance = item

        let bar = UITabBar.appearance()
        bar.standardAppearance = appearance
        bar.scrollEdgeAppearance = appearance
        bar.tintColor = .label
        bar.unselectedItemTintColor = .systemGray
        bar.isTranslucent = false
    }
}
