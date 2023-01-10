import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttering/fluttering.dart';
import 'package:fluttering_ads/advertisement/custom_ads/custom_advertisement.dart';
import 'package:fluttering_ads/advertisement/index.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class IAwesomeAdvertisement extends Provider with ProviderDelegate {
  AdvertisementConfig get config;

  void initial(AdvertisementConfig config);

  void restore();

  void handleAd([AdvertisementItem? ad]);

  Widget? widgetAd([AdvertisementItem? ad]);
}

class AwesomeAdvertisement extends IAwesomeAdvertisement {
  static final IAwesomeAdvertisement _instance = AwesomeAdvertisement._internal();
  static IAwesomeAdvertisement get instance => _instance;

  factory AwesomeAdvertisement() => _instance as AwesomeAdvertisement;

  AwesomeAdvertisement._internal();

  AdvertisementConfig _config = const AdvertisementConfig();
  @override
  AdvertisementConfig get config => _config;

  final Map<AdvertisementViewType, Map<AdvertisementItem, dynamic>> _adLoadedList = {};

  final _advertisements = {
    AdvertisementProvider.google: GoogleAdvertisement(),
    AdvertisementProvider.huawei: HuaweiAdvertisement(),
    AdvertisementProvider.custom: CustomAdvertisement(),
  };

  @override
  void initial(AdvertisementConfig config) {
    _config = config;

    /// CHECKING ADS IS ENABLED
    if (!config.enable) return;

    /// CHECKING HAVE GOOGLE ADS
    bool googleAds = false;
    for (final ad in config.ads) {
      if (!googleAds && ad.provider == AdvertisementProvider.google) {
        googleAds = true;
        break;
      }
    }

    /// GOOGLE ADS MOBILE INITITAL
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

  @override
  void restore([AdvertisementViewType? viewType]) {
    /// CHECKING ADS IS ENABLED
    if (!config.enable) return;

    /// LOAD ALL ADS
    for (var ad in config.ads) {
      if (viewType != null && ad.viewType != viewType) return;
      if (_advertisements.containsKey(ad.provider)) {
        if (_advertisements[ad.provider]!.isSupported) {
          if (!_adLoadedList.containsKey(ad.viewType)) {
            _adLoadedList[ad.viewType] = {};
          } else if (_adLoadedList[ad.viewType]!.containsKey(ad)) {
            /// LOADED AD YET
            return;
          }

          /// AD IS NOT LOADED
          if (ad.viewType == AdvertisementViewType.widget) {
            final widget = _advertisements[ad.provider]!.createAdWidget(adItem: ad);
            if (widget != null) {
              /// WIDGET ADS (BANNER, FLUID, ROLL)
              _adLoadedList[ad.viewType]!.addEntries([MapEntry(ad, widget)]);
            }
          } else {
            /// OPEN APP ADS AND HANDLER ADS
            _advertisements[ad.provider]!.loadAd(
              adItem: ad,
              onLoadedAd: (loadedAd) {
                _adLoadedList[ad.viewType]!.addEntries([MapEntry(ad, loadedAd)]);
              },
            );
          }
        }
      }
    }
  }

  @override
  void handleAd([AdvertisementItem? ad]) {
    /// CHECKING ADS IS ENABLED
    if (!config.enable) return;

    if (_adLoadedList[AdvertisementViewType.handle] != null && _adLoadedList[AdvertisementViewType.handle]!.isNotEmpty) {
      if (ad != null && _adLoadedList[AdvertisementViewType.handle]!.containsKey(ad)) {
        /// LOAD FROM LOADED ADS
        final adItem = ad;
        final adLoaded = _adLoadedList[AdvertisementViewType.handle]![adItem];
        _advertisements[adItem.provider]!.showLoadedAd(loadedAd: adLoaded, type: adItem.type);
        _adLoadedList[AdvertisementViewType.handle]!.remove(adItem);
      } else {
        /// RANDOM LOAD FROM LOADED ADS
        final adItem = _adLoadedList[AdvertisementViewType.handle]!.keys.first;
        final adLoaded = _adLoadedList[AdvertisementViewType.handle]!.values.first;
        _advertisements[adItem.provider]!.showLoadedAd(loadedAd: adLoaded, type: adItem.type);
        _adLoadedList[AdvertisementViewType.handle]!.remove(adItem);
      }
    } else {
      /// RESTORE ADS
      restore(AdvertisementViewType.handle);
    }
  }

  @override
  Widget? widgetAd([AdvertisementItem? ad]) {
    /// CHECKING ADS IS ENABLED
    if (!config.enable) return null;

    if (_adLoadedList[AdvertisementViewType.widget] != null && _adLoadedList[AdvertisementViewType.widget]!.isNotEmpty) {
      if (ad != null && _adLoadedList[AdvertisementViewType.widget]!.containsKey(ad)) {
        /// LOAD FROM LOADED ADS
        final adItem = ad;
        final adLoaded = _adLoadedList[AdvertisementViewType.widget]![adItem];
        _adLoadedList[AdvertisementViewType.widget]!.remove(adItem);
        return adLoaded;
      }

      /// RANDOM LOAD FROM LOADED ADS
      final adItem = _adLoadedList[AdvertisementViewType.widget]!.keys.first;
      final adLoaded = _adLoadedList[AdvertisementViewType.widget]!.values.first;
      _adLoadedList[AdvertisementViewType.widget]!.remove(adItem);
      return adLoaded;
    }

    /// RESTORE ADS
    restore(AdvertisementViewType.widget);
    return null;
  }

  @override
  Future<bool> changedAppLifecycleState(AppLifecycleState state) async {
    /// CHECKING ADS IS ENABLED
    if (!config.enable) return super.changedAppLifecycleState(state);

    /// LOAD FROM LOADED ADS
    switch (state) {
      case AppLifecycleState.inactive:
        restore();
        break;
      case AppLifecycleState.resumed:
        if (_adLoadedList[AdvertisementViewType.openApp] != null && _adLoadedList[AdvertisementViewType.openApp]!.isNotEmpty) {
          var adLoaded = _adLoadedList[AdvertisementViewType.openApp]!.values.first;
          var adItem = _adLoadedList[AdvertisementViewType.openApp]!.keys.first;
          _advertisements[adItem.provider]!.showLoadedAd(loadedAd: adLoaded, type: adItem.type);
          _adLoadedList[AdvertisementViewType.openApp]!.remove(adItem);
        } else if (_adLoadedList[AdvertisementViewType.handle] != null && _adLoadedList[AdvertisementViewType.handle]!.isNotEmpty) {
          var adLoaded = _adLoadedList[AdvertisementViewType.handle]!.values.first;
          var adItem = _adLoadedList[AdvertisementViewType.handle]!.keys.first;
          _advertisements[adItem.provider]!.showLoadedAd(loadedAd: adLoaded, type: adItem.type);
          _adLoadedList[AdvertisementViewType.openApp]!.remove(adItem);
        }
        break;
      default:
    }
    return super.changedAppLifecycleState(state);
  }
}
