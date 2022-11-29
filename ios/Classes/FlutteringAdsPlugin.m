#import "FlutteringAdsPlugin.h"
#if __has_include(<fluttering_ads/fluttering_ads-Swift.h>)
#import <fluttering_ads/fluttering_ads-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "fluttering_ads-Swift.h"
#endif

@implementation FlutteringAdsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutteringAdsPlugin registerWithRegistrar:registrar];
}
@end
