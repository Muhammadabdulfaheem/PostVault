import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

    /// The "BackgroundDisabled" asset catalog color resource.
    static let backgroundDisabled = ColorResource(name: "BackgroundDisabled", bundle: resourceBundle)

    /// The "DisabledTextColor" asset catalog color resource.
    static let disabledText = ColorResource(name: "DisabledTextColor", bundle: resourceBundle)

    /// The "OutlineColor" asset catalog color resource.
    static let outline = ColorResource(name: "OutlineColor", bundle: resourceBundle)

    /// The "PrimaryButtonColor" asset catalog color resource.
    static let primaryButton = ColorResource(name: "PrimaryButtonColor", bundle: resourceBundle)

    /// The "PrimaryTextColor" asset catalog color resource.
    static let primaryText = ColorResource(name: "PrimaryTextColor", bundle: resourceBundle)

    /// The "SecondaryTextColor" asset catalog color resource.
    static let secondaryText = ColorResource(name: "SecondaryTextColor", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// The "BackgroundDisabled" asset catalog color.
    static var backgroundDisabled: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .backgroundDisabled)
#else
        .init()
#endif
    }

    /// The "DisabledTextColor" asset catalog color.
    static var disabledText: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .disabledText)
#else
        .init()
#endif
    }

    /// The "OutlineColor" asset catalog color.
    static var outline: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .outline)
#else
        .init()
#endif
    }

    /// The "PrimaryButtonColor" asset catalog color.
    static var primaryButton: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .primaryButton)
#else
        .init()
#endif
    }

    /// The "PrimaryTextColor" asset catalog color.
    static var primaryText: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .primaryText)
#else
        .init()
#endif
    }

    /// The "SecondaryTextColor" asset catalog color.
    static var secondaryText: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .secondaryText)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// The "BackgroundDisabled" asset catalog color.
    static var backgroundDisabled: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .backgroundDisabled)
#else
        .init()
#endif
    }

    /// The "DisabledTextColor" asset catalog color.
    static var disabledText: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .disabledText)
#else
        .init()
#endif
    }

    /// The "OutlineColor" asset catalog color.
    static var outline: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .outline)
#else
        .init()
#endif
    }

    /// The "PrimaryButtonColor" asset catalog color.
    static var primaryButton: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .primaryButton)
#else
        .init()
#endif
    }

    /// The "PrimaryTextColor" asset catalog color.
    static var primaryText: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .primaryText)
#else
        .init()
#endif
    }

    /// The "SecondaryTextColor" asset catalog color.
    static var secondaryText: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .secondaryText)
#else
        .init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// The "BackgroundDisabled" asset catalog color.
    static var backgroundDisabled: SwiftUI.Color { .init(.backgroundDisabled) }

    /// The "DisabledTextColor" asset catalog color.
    static var disabledText: SwiftUI.Color { .init(.disabledText) }

    /// The "OutlineColor" asset catalog color.
    static var outline: SwiftUI.Color { .init(.outline) }

    /// The "PrimaryButtonColor" asset catalog color.
    static var primaryButton: SwiftUI.Color { .init(.primaryButton) }

    /// The "PrimaryTextColor" asset catalog color.
    static var primaryText: SwiftUI.Color { .init(.primaryText) }

    /// The "SecondaryTextColor" asset catalog color.
    static var secondaryText: SwiftUI.Color { .init(.secondaryText) }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    /// The "BackgroundDisabled" asset catalog color.
    static var backgroundDisabled: SwiftUI.Color { .init(.backgroundDisabled) }

    /// The "DisabledTextColor" asset catalog color.
    static var disabledText: SwiftUI.Color { .init(.disabledText) }

    /// The "OutlineColor" asset catalog color.
    static var outline: SwiftUI.Color { .init(.outline) }

    /// The "PrimaryButtonColor" asset catalog color.
    static var primaryButton: SwiftUI.Color { .init(.primaryButton) }

    /// The "PrimaryTextColor" asset catalog color.
    static var primaryText: SwiftUI.Color { .init(.primaryText) }

    /// The "SecondaryTextColor" asset catalog color.
    static var secondaryText: SwiftUI.Color { .init(.secondaryText) }

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    private convenience init?(thinnableResource: ColorResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Swift.Hashable, Swift.Sendable {

    /// An asset catalog color resource name.
    fileprivate let name: Swift.String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Foundation.Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: Swift.String, bundle: Foundation.Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Swift.Hashable, Swift.Sendable {

    /// An asset catalog image resource name.
    fileprivate let name: Swift.String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Foundation.Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: Swift.String, bundle: Foundation.Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif