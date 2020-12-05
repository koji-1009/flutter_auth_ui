#import "FlutterAuthUiPlugin.h"
#if __has_include(<flutter_auth_ui/flutter_auth_ui-Swift.h>)
#import <flutter_auth_ui/flutter_auth_ui-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_auth_ui-Swift.h"
#endif

@implementation FlutterAuthUiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAuthUiPlugin registerWithRegistrar:registrar];
}
@end
