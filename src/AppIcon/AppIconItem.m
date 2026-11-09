// AppIconItem.m
// NeoFreeBird
//

#import "AppIconItem.h"
#import <notify.h>
#import <roothide.h>

NSString* const AppIconVirtualPrefix = @"TR:";

static NSString* const kIconNotificationPrefix = @"com.qn.twitterrebrand.icon.";
static NSString* const kDefaultVirtualIcon = @"ProductionAppIcon";

@implementation AppIconItem

- (instancetype)initWithBundleIconName:(NSString*)iconName
                         iconFileNames:(NSArray<NSString*>*)files
                         isPrimaryIcon:(BOOL)isPrimary {
    if (self = [super init]) {
        _bundleIconName = [iconName copy];
        _bundleIconFiles = [files copy];
        _isPrimaryIcon = isPrimary;
    }
    return self;
}

- (instancetype)initWithVirtualIconName:(NSString*)iconName path:(NSString*)path {
    if (self = [super init]) {
        _bundleIconName = [iconName copy];
        _bundleIconFiles = @[];
        _isPrimaryIcon = NO;
        _virtualIconPath = [path copy];
    }
    return self;
}

@end

NSArray<AppIconItem*>* AppIconVirtualItems(void) {
    // jbroot() maps to the right prefix on rootful, rootless and roothide, and
    // to a path that does not exist on sideloaded builds (so the list is empty).
    NSString* directory = jbroot(@"/Library/Application Support/TwitterRebrand/Icons");
    NSArray<NSString*>* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory
                                                                                    error:nil];
    NSMutableArray<NSString*>* names = [NSMutableArray new];
    for (NSString* file in files) {
        if ([file.pathExtension isEqualToString:@"png"]) {
            [names addObject:file.stringByDeletingPathExtension];
        }
    }
    [names sortUsingSelector:@selector(caseInsensitiveCompare:)];
    if ([names containsObject:kDefaultVirtualIcon]) {
        [names removeObject:kDefaultVirtualIcon];
        [names insertObject:kDefaultVirtualIcon atIndex:0];
    }

    NSMutableArray<AppIconItem*>* items = [NSMutableArray arrayWithCapacity:names.count];
    for (NSString* name in names) {
        NSString* path = [[directory stringByAppendingPathComponent:name]
            stringByAppendingPathExtension:@"png"];
        [items addObject:[[AppIconItem alloc] initWithVirtualIconName:name path:path]];
    }
    return items;
}

void AppIconNotifyOverride(NSString* name) {
    notify_post([kIconNotificationPrefix stringByAppendingString:name].UTF8String);
}
