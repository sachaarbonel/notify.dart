#import "NotifyPlugin.h"
#if __has_include(<notify/notify-Swift.h>)
#import <notify/notify-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "notify-Swift.h"
#endif

@implementation NotifyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNotifyPlugin registerWithRegistrar:registrar];
}
@end
