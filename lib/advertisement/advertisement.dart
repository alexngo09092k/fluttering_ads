import 'package:flutter/material.dart';
import 'package:fluttering/fluttering.dart';
import 'package:fluttering_ads/advertisement/custom_ads/custom_advertisement.dart';
import 'package:fluttering_ads/advertisement/index.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class IAwesomeAdvertisement extends Provider with ProviderDelegate {
  AdvertisementConfig get config;

  void initial(AdvertisementConfig config);

  void restore();

  Widget? getAdWidget(Size size);

  void showAd();
}

class AwesomeAdvertisement extends IAwesomeAdvertisement {
  static final IAwesomeAdvertisement _instance = AwesomeAdvertisement._internal();
  static IAwesomeAdvertisement get instance => _instance;

  factory AwesomeAdvertisement() => _instance as AwesomeAdvertisement;

  AwesomeAdvertisement._internal();

  AdvertisementConfig _config = const AdvertisementConfig();
  @override
  AdvertisementConfig get config => _config;

  final List<AdvertisementView> _listAdView = [];

  final Map<AdvertisementViewType, Map<AdvertisementView, dynamic>> _listAdLoadedView = {};

  final _advertisements = {
    AdvertisementProvider.google: GoogleAdvertisement(),
    AdvertisementProvider.huawei: HuaweiAdvertisement(),
    AdvertisementProvider.custom: CustomAdvertisement(),
  };

  @override
  void initial(AdvertisementConfig config) {
    _config = config;
    if (config.enable) {
      bool googleAds = false;
      for (final ad in config.ads) {
        if (!googleAds && ad.provider == AdvertisementProvider.google) googleAds = true;
        var adView = AdvertisementView(data: ad);
        _listAdView.add(adView);
      }
      if (googleAds) {
        MobileAds.instance.initialize().then((InitializationStatus status) {
          Debug.log('Google Mobile Ads Initialization Done: ${status.adapterStatuses}');
          MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
            tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
          ));
        });
      }
      restore();
    }
  }

  @override
  void restore([AdvertisementViewType? type]) {
    if (!config.enable) return;
    for (var adView in _listAdView) {
      if (type != null && adView.type != type) return;
      if (_advertisements.containsKey(adView.data!.provider)) {
        if (_advertisements[adView.data!.provider]!.isSupported()) {
          if (!_listAdLoadedView.containsKey(adView.type)) {
            _listAdLoadedView[adView.type] = {};
          } else if (_listAdLoadedView[adView.type]!.containsKey(adView.data!.id)) {
            /// Loaded ads
            return;
          }

          /// Not load ads yet
          if (adView.type == AdvertisementViewType.widget) {
            final widget = _advertisements[adView.data!.provider]!.createAdWidget(adItem: adView.data!);
            if (widget != null) {
              /// Added widget ads
              _listAdLoadedView[adView.type]!.addEntries([MapEntry(adView, widget)]);
            }
          } else {
            _advertisements[adView.data!.provider]!.loadAd(
              adItem: adView.data!,
              onLoadedAd: (loadedAd) {
                /// Added handler ads
                /// Added open app ads
                _listAdLoadedView[adView.type]!.addEntries([MapEntry(adView, loadedAd)]);
              },
            );
          }
        }
      }
    }
  }

  @override
  void showAd() {
    if (!config.enable) return;
    if (_listAdLoadedView[AdvertisementViewType.handle] != null && _listAdLoadedView[AdvertisementViewType.handle]!.isNotEmpty) {
      var loadedAd = _listAdLoadedView[AdvertisementViewType.handle]!.values.first;
      var adView = _listAdLoadedView[AdvertisementViewType.handle]!.keys.first;
      _advertisements[adView.data!.provider]!.showLoadedAd(loadedAd: loadedAd, type: adView.data!.type);
      _listAdLoadedView.remove(adView);
    } else {
      restore(AdvertisementViewType.handle);
    }
  }

  @override
  Widget? getAdWidget(Size size) {
    if (!config.enable) return null;
    if (_listAdLoadedView[AdvertisementViewType.widget] != null && _listAdLoadedView[AdvertisementViewType.widget]!.isNotEmpty) {
      var loadedAd = _listAdLoadedView[AdvertisementViewType.widget]!.values.first;
      var adView = _listAdLoadedView[AdvertisementViewType.widget]!.keys.first;
      _listAdLoadedView.remove(adView);
      return loadedAd as Widget;
    } else {
      restore(AdvertisementViewType.widget);
    }
    return null;
  }

  @override
  Future<bool> changedAppLifecycleState(AppLifecycleState state) {
    if (!config.enable) return super.changedAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        restore();
        break;
      case AppLifecycleState.resumed:
        if (_listAdLoadedView[AdvertisementViewType.openApp] != null && _listAdLoadedView[AdvertisementViewType.openApp]!.isNotEmpty) {
          var loadedAd = _listAdLoadedView[AdvertisementViewType.openApp]!.values.first;
          var adView = _listAdLoadedView[AdvertisementViewType.openApp]!.keys.first;
          _advertisements[adView.data!.provider]!.showLoadedAd(loadedAd: loadedAd, type: adView.data!.type);
          _listAdLoadedView.remove(adView);
        } else if (_listAdLoadedView[AdvertisementViewType.handle] != null && _listAdLoadedView[AdvertisementViewType.handle]!.isNotEmpty) {
          var loadedAd = _listAdLoadedView[AdvertisementViewType.handle]!.values.first;
          var adView = _listAdLoadedView[AdvertisementViewType.handle]!.keys.first;
          _advertisements[adView.data!.provider]!.showLoadedAd(loadedAd: loadedAd, type: adView.data!.type);
          _listAdLoadedView.remove(adView);
        }
        break;
      default:
    }
    return super.changedAppLifecycleState(state);
  }
}
