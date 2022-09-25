#import "AppinioSocialSharePlugin.h"
#if __has_include(<appinio_social_share/appinio_social_share-Swift.h>)
#import <appinio_social_share/appinio_social_share-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "appinio_social_share-Swift.h"
#endif

@implementation AppinioSocialSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAppinioSocialSharePlugin registerWithRegistrar:registrar];
}
@end
