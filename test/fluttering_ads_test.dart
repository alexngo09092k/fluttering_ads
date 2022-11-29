import 'package:flutter_test/flutter_test.dart';
import 'package:fluttering_ads/fluttering_ads_platform_interface.dart';
import 'package:fluttering_ads/fluttering_ads_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutteringAdsPlatform
    with MockPlatformInterfaceMixin
    implements FlutteringAdsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutteringAdsPlatform initialPlatform = FlutteringAdsPlatform.instance;

  test('$MethodChannelFlutteringAds is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutteringAds>());
  });

  test('getPlatformVersion', () async {
    // FlutteringAds flutteringAdsPlugin = FlutteringAds();
    MockFlutteringAdsPlatform fakePlatform = MockFlutteringAdsPlatform();
    FlutteringAdsPlatform.instance = fakePlatform;

    // expect(await flutteringAdsPlugin.getPlatformVersion(), '42');
  });
}
