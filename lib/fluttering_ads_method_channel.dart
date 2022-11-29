import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fluttering_ads_platform_interface.dart';

/// An implementation of [FlutteringAdsPlatform] that uses method channels.
class MethodChannelFlutteringAds extends FlutteringAdsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fluttering_ads');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
