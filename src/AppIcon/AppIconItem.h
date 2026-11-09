// AppIconItem.h
// NeoFreeBird
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppIconItem : NSObject

/// the key used in Info.plist (and passed to setAlternateIconName:)
@property (nonatomic, copy, readonly) NSString* bundleIconName;

/// the array of filenames (without “.png”) from CFBundleIconFiles
@property (nonatomic, copy, readonly) NSArray<NSString*>* bundleIconFiles;

/// is this the primary (default) icon?
@property (nonatomic, assign, readonly) BOOL isPrimaryIcon;

/// Path of the PNG for an icon that is not declared in Info.plist. Such "virtual"
/// icons are shipped by the TwitterRebrand tweak, which draws the chosen one on the
/// Home Screen; iOS never knows about them. nil for icons declared in Info.plist.
@property (nonatomic, copy, readonly, nullable) NSString* virtualIconPath;

- (instancetype)initWithBundleIconName:(NSString*)iconName
                         iconFileNames:(NSArray<NSString*>*)files
                         isPrimaryIcon:(BOOL)isPrimary;

- (instancetype)initWithVirtualIconName:(NSString*)iconName path:(NSString*)path;

@end

/// Value prefix under which a virtual icon is remembered in the shared
/// "last selected icon" setting, so it cannot clash with an Info.plist icon name.
FOUNDATION_EXPORT NSString* const AppIconVirtualPrefix;

/// The virtual icons TwitterRebrand ships, sorted with its default icon first.
/// Empty when the tweak is not installed.
FOUNDATION_EXPORT NSArray<AppIconItem*>* AppIconVirtualItems(void);

/// Tell the TwitterRebrand tweak (running in SpringBoard) which icon to draw.
/// Pass a virtual icon's name, or @"none" to show the app's real icon again.
FOUNDATION_EXPORT void AppIconNotifyOverride(NSString* name);

NS_ASSUME_NONNULL_END
