#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"dd.PostVault";

/// The "BackgroundDisabled" asset catalog color resource.
static NSString * const ACColorNameBackgroundDisabled AC_SWIFT_PRIVATE = @"BackgroundDisabled";

/// The "DisabledTextColor" asset catalog color resource.
static NSString * const ACColorNameDisabledTextColor AC_SWIFT_PRIVATE = @"DisabledTextColor";

/// The "OutlineColor" asset catalog color resource.
static NSString * const ACColorNameOutlineColor AC_SWIFT_PRIVATE = @"OutlineColor";

/// The "PrimaryButtonColor" asset catalog color resource.
static NSString * const ACColorNamePrimaryButtonColor AC_SWIFT_PRIVATE = @"PrimaryButtonColor";

/// The "PrimaryTextColor" asset catalog color resource.
static NSString * const ACColorNamePrimaryTextColor AC_SWIFT_PRIVATE = @"PrimaryTextColor";

/// The "SecondaryTextColor" asset catalog color resource.
static NSString * const ACColorNameSecondaryTextColor AC_SWIFT_PRIVATE = @"SecondaryTextColor";

#undef AC_SWIFT_PRIVATE
