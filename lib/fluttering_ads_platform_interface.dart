import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fluttering_ads_method_channel.dart';

abstract class FlutteringAdsPlatform extends PlatformInterface {
  /// Constructs a FlutteringAdsPlatform.
  FlutteringAdsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutteringAdsPlatform _instance = MethodChannelFlutteringAds();

  /// The default instance of [FlutteringAdsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutteringAds].
  static FlutteringAdsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutteringAdsPlatform] when
  /// they register themselves.
  static set instance(FlutteringAdsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
