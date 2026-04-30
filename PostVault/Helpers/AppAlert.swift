import UIKit

enum AppAlert {
    static func show(
        on controller: UIViewController,
        title: String = "Alert",
        message: String,
        style: UIAlertController.Style = .alert,
        actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default)]
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach(alert.addAction)
        controller.present(alert, animated: true)
    }

    
    static func showSuccess(
        on controller: UIViewController,
        title: String = "Success",
        message: String,
        onOK: (() -> Void)? = nil
    ) {
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            onOK?()
        }
        show(on: controller, title: title, message: message, actions: [ok])
    }

    /// Two-button confirmation: **Cancel** dismisses; **OK** runs `onConfirm`.
    static func showConfirmation(
        on controller: UIViewController,
        title: String,
        message: String,
        confirmTitle: String = "OK",
        cancelTitle: String = "Cancel",
        onConfirm: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(
            UIAlertAction(title: confirmTitle, style: .default) { _ in
                onConfirm()
            }
        )
        controller.present(alert, animated: true)
    }
}
