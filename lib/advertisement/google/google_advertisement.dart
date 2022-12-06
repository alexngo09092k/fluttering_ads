import 'package:flutter/material.dart';
import 'package:fluttering/fluttering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../models/advertisement_type.dart';
import '../models/advertisement_provider.dart';
import '../models/advertisement_item.dart';
import '../base_advertisement.dart';

part 'ads/banner_ad.dart';
part 'ads/native_ad.dart';
part 'ads/fluid_ad.dart';
part 'ads/reward_ad.dart';
part 'ads/interstitial_ad.dart';
part 'ads/open_app_ad.dart';

class GoogleAdvertisement extends AdvertisementBase {
  @override
  AdvertisementProvider get adsProvider => AdvertisementProvider.google;

  final Map<String, Ad> _ads = {};

  @override
  Widget createAdWidget({
    required AdvertisementItem adItem,
    Function(dynamic)? onLoadedAd,
    Function(dynamic error)? onAdFailedToLoad,
  }) {
    switch (adItem.type) {
      case AdvertisementType.banner:
        var bannerAd = _loadBannerAd(adItem, null, onLoadedAd, onAdFailedToLoad);
        return Container(
          alignment: Alignment.center,
          width: adItem.width ?? bannerAd.size.width.toDouble(),
          height: adItem.height ?? bannerAd.size.height.toDouble(),
          child: AdWidget(ad: bannerAd),
        );
      case AdvertisementType.fluid:
        var fluidAd = _loadFluidAd(adItem, null, onLoadedAd, onAdFailedToLoad);
        return Container(
          width: adItem.width,
          height: adItem.height,
          alignment: Alignment.center,
          child: AdWidget(ad: fluidAd),
        );
      case AdvertisementType.native:
        var nativeAd = _loadNativeAd(adItem, null, onLoadedAd, onAdFailedToLoad);
        return Container(
          width: adItem.width,
          height: adItem.height,
          alignment: Alignment.center,
          child: AdWidget(ad: nativeAd),
        );
      default:
        return const SizedBox();
    }
  }

  @override
  void loadAd({
    required AdvertisementItem adItem,
    Function(dynamic)? onAd,
    Function(Ad)? onLoadedAd,
    Function(LoadAdError error)? onAdFailedToLoad,
  }) {
    switch (adItem.type) {
      case AdvertisementType.banner:
        _loadBannerAd(adItem, onAd, onLoadedAd, onAdFailedToLoad);
        break;
      case AdvertisementType.fluid:
        _loadFluidAd(adItem, onAd, onLoadedAd, onAdFailedToLoad);
        break;
      case AdvertisementType.native:
        _loadNativeAd(adItem, onAd, onLoadedAd, onAdFailedToLoad);
        break;
      case AdvertisementType.reward:
        _loadRewardAd(adItem, onAd, onLoadedAd, onAdFailedToLoad);
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
  showAd({required AdvertisementItem adItem}) {
    loadAd(
      adItem: adItem,
      onLoadedAd: (ad) {
        switch (adItem.type) {
          case AdvertisementType.reward:
            (ad as RewardedAd).show(onUserEarnedReward: (_, __) {});
            break;
          case AdvertisementType.interstitial:
            (ad as InterstitialAd).show();
            break;
          case AdvertisementType.openApp:
            (ad as AppOpenAd).show();
            break;
          default:
            break;
        }
      },
    );
  }

  @override
  bool get isSupported => CurrentPlatform.instance.isMobile;

  @override
  void hideAd(AdvertisementItem adItem) {
    if (_ads.containsKey(adItem.id)) {
      _ads[adItem.id]!.dispose();
      _ads.remove(adItem.id);
    }
  }

  @override
  void showLoadedAd({required loadedAd, required AdvertisementType type}) {
    switch (type) {
      case AdvertisementType.reward:
        (loadedAd as RewardedAd).show(onUserEarnedReward: (_, __) {});
        break;
      case AdvertisementType.interstitial:
        (loadedAd as InterstitialAd).show();
        break;
      case AdvertisementType.openApp:
        (loadedAd as AppOpenAd).show();
        break;
      default:
        break;
    }
  }

  @override
  void hideLoadedAd({required loadedAd, required AdvertisementType type}) {
    loadedAd!.dispose();
  }
}
