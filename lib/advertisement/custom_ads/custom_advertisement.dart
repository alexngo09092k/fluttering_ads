import 'package:flutter/material.dart';
import 'package:fluttering/fluttering.dart';

import '../base_advertisement.dart';
import '../models/advertisement_item.dart';
import '../models/advertisement_provider.dart';
import '../models/advertisement_type.dart';

part 'ads/banner_ad.dart';
part 'ads/custom_ad.dart';
part 'ads/interstitial_ad.dart';
part 'ads/open_app_ad.dart';

class CustomAdvertisement extends BaseAdvertisement {
  @override
  AdvertisementProvider get provider => AdvertisementProvider.custom;

  final Map<String, CustomAd> _ads = {};

  @override
  Widget createAdWidget({required AdvertisementItem adItem, Function(dynamic)? onLoadedAd, Function(dynamic error)? onAdFailedToLoad}) {
    if (!isSupported) {
      if (onAdFailedToLoad != null) onAdFailedToLoad(ErrorDescription("This device not support Ads"));
      return const SizedBox();
    }

    switch (adItem.type) {
      case AdvertisementType.banner:
        var bannerAd = _loadBannerAd(adItem, null, onLoadedAd, onAdFailedToLoad);
        return Container(
          alignment: Alignment.center,
          width: adItem.width,
          height: adItem.height,
          child: CustomAdWidget(ad: bannerAd),
        );
      default:
        return const SizedBox();
    }
  }

  @override
  void hideAd(AdvertisementItem adItem) {
    if (_ads.containsKey(adItem.id)) {
      _ads[adItem.id]!.dispose();
      _ads.remove(adItem.id);
    }
  }

  @override
  void hideLoadedAd({required loadedAd, required AdvertisementType type}) {
    if (!isSupported) return;
    (loadedAd as CustomAd).dispose();
  }

  @override
  bool get isSupported => CurrentPlatform.instance.isMobile;

  @override
  void loadAd({
    required AdvertisementItem adItem,
    Function(dynamic p1)? onAd,
    Function(dynamic ad)? onLoadedAd,
    Function(dynamic error)? onAdFailedToLoad,
  }) {
    if (!isSupported) {
      if (onAdFailedToLoad != null) onAdFailedToLoad(ErrorDescription("This device not support Ads"));
      return;
    }

    switch (adItem.type) {
      case AdvertisementType.banner:
        _loadBannerAd(adItem, onAd, onLoadedAd, onAdFailedToLoad);
        break;
      case AdvertisementType.interstitial:
        _loadInterstitialAd(adItem, onAd, onLoadedAd, onAdFailedToLoad);
        break;
      case AdvertisementType.openApp:
        _loadOpenAppAd(adItem, onAd, onLoadedAd, onAdFailedToLoad);
        break;
      default:
        break;
    }
  }

  @override
  void showAd({required AdvertisementItem adItem, Function(dynamic)? onAdFailedToLoad}) {
    if (!isSupported) {
      if (onAdFailedToLoad != null) onAdFailedToLoad(ErrorDescription("This device not support Ads"));
      return;
    }
    return loadAd(
      adItem: adItem,
      onLoadedAd: (ad) {
        (ad as CustomAd).show();
      },
      onAdFailedToLoad: onAdFailedToLoad,
    );
  }

  @override
  void showLoadedAd({required loadedAd, required AdvertisementType type}) {
    if (!isSupported) return;
    (loadedAd as CustomAd).show();
  }

  @override
  Future<bool> initial() async {
    return true;
  }
}
