import UIKit

enum AppColor: String, CaseIterable {
    case backgroundDisabled = "BackgroundDisabled"
    case disabledText = "DisabledTextColor"
    case primaryButton = "PrimaryButtonColor"
    case primaryText = "PrimaryTextColor"
    case secondaryText = "SecondaryTextColor"
    case outlineColor = "OutlineColor"
}


extension AppColor {

    var color: UIColor {
        if let named = UIColor(named: rawValue, in: .main, compatibleWith: nil) {
            return named
        }
        return UIColor()
    }

}

extension UIColor {

    enum App {
        static var backgroundDisabled: UIColor { AppColor.backgroundDisabled.color }
        static var disabledText: UIColor { AppColor.disabledText.color }
        static var primaryButton: UIColor { AppColor.primaryButton.color }
        static var primaryText: UIColor { AppColor.primaryText.color }
        static var secondaryText: UIColor { AppColor.secondaryText.color }
        static var outlineColor: UIColor { AppColor.outlineColor.color }
    }
}
