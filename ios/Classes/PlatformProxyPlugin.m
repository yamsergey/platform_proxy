#import "PlatformProxyPlugin.h"
#if __has_include(<platform_proxy/platform_proxy-Swift.h>)
#import <platform_proxy/platform_proxy-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "platform_proxy-Swift.h"
#endif

@implementation PlatformProxyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPlatformProxyPlugin registerWithRegistrar:registrar];
}
@end
