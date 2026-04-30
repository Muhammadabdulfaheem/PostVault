import UIKit

final class LoginRouter: RouterProtocol, LoginViewControllerDelegate {
    var onAuthenticated: (() -> Void)?

    func start() -> UIViewController {
        let storyboard = StoryboardName.login.storyboard
        let viewController = storyboard.instantiateViewController(
            withIdentifier: StoryboardName.ID.loginViewController
        )
        guard let loginVC = viewController as? LoginViewController else {
            fatalError(
                "\(StoryboardName.login.rawValue).storyboard: expected LoginViewController with id '\(StoryboardName.ID.loginViewController)'."
            )
        }

        loginVC.configure(flowDelegate: self)

        return UINavigationController(rootViewController: loginVC)
    }

    func loginViewControllerDidAuthenticate(_ controller: LoginViewController) {
        onAuthenticated?()
    }
}
