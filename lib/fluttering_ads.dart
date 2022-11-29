
import 'fluttering_ads_platform_interface.dart';

class FlutteringAds {
  Future<String?> getPlatformVersion() {
    return FlutteringAdsPlatform.instance.getPlatformVersion();
  }
}
