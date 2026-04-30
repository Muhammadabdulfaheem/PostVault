import UIKit

final class AppBootstrapper {
    private let window: UIWindow

    private var loginRouter: LoginRouter?
    private var tabRouter: TabRouter?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        AppAppearance.apply()
        if ProcessInfo.processInfo.environment["UITEST"] == "1" {
            AppServices.sessionRepository.logout()
        }
        if AppServices.sessionRepository.isLoggedIn {
            routeToMain()
        } else {
            routeToLogin()
        }
        window.makeKeyAndVisible()
    }

    private func routeToLogin() {
        let router = LoginRouter()
        router.onAuthenticated = { [weak self] in
            self?.routeToMain()
        }
        loginRouter = router
        tabRouter = nil
        window.rootViewController = router.start()
    }

    private func routeToMain() {
        let router = TabRouter()
        router.onLogout = { [weak self] in
            AppServices.sessionRepository.logout()
            self?.routeToLogin()
        }
        tabRouter = router
        loginRouter = nil
        window.rootViewController = router.start()
    }
}
