import UIKit

final class MainTabBarController: UITabBarController {
    var onLogout: (() -> Void)?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
