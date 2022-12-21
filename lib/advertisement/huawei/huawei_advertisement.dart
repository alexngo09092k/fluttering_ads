import 'package:flutter/material.dart';
import 'package:fluttering/fluttering.dart';
import 'package:huawei_ads/huawei_ads.dart';

import '../models/advertisement_type.dart';
import '../models/advertisement_provider.dart';
import '../models/advertisement_item.dart';
import '../base_advertisement.dart';

part 'ads/native_ad.dart';
part 'ads/banner_ad.dart';
part 'ads/splash_ad.dart';
part 'ads/instream_ad.dart';
part 'ads/interstitial_ad.dart';
part 'ads/reward_ad.dart';

class HuaweiAdvertisement extends BaseAdvertisement {
  @override
  AdvertisementProvider get provider => AdvertisementProvider.huawei;

  final Map<String, dynamic> _ads = {};

  @override
  Widget createAdWidget({
    required AdvertisementItem adItem,
    Function(dynamic)? onLoadedAd,
    Function(dynamic error)? onAdFailedToLoad,
  }) {
    switch (adItem.type) {
      case AdvertisementType.native:
        var nativeAd = _loadNativeAd(
            adItem,
            null,
            onLoadedAd,
            onAdFailedToLoad,
            adItem.height == null
                ? NativeAdType.full
                : adItem.height! < 100
                    ? NativeAdType.small
                    : NativeAdType.banner);
        return Container(
          width: adItem.width,
          height: adItem.height,
          alignment: Alignment.center,
          child: nativeAd,
        );
      case AdvertisementType.roll:
        return FutureBuilder<InstreamAdView?>(
            future: _loadInstreamAdView(adItem, null, onLoadedAd, onAdFailedToLoad),
            builder: (_, snapshot) => Container(
                  width: adItem.width,
                  height: adItem.height,
                  alignment: Alignment.center,
                  child: snapshot.data ?? const SizedBox(),
                ));
      default:
        return const SizedBox();
    }
  }

  @override
  void loadAd({
    required AdvertisementItem adItem,
    Function(dynamic)? onAd,
    Function(dynamic)? onLoadedAd,
    Function(int? error)? onAdFailedToLoad,
  }) {
    switch (adItem.type) {
      case AdvertisementType.banner:
        _loadBannerAd(adItem, onAd, onLoadedAd, onAdFailedToLoad);
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
      case AdvertisementType.roll:
        _loadInstreamAdView(adItem, onAd, onLoadedAd, onAdFailedToLoad);
        break;
      case AdvertisementType.splash:
        _loadSplashAd(adItem, onAd, onLoadedAd, onAdFailedToLoad);
        break;
      default:
        break;
    }
  }

  @override
  showAd({required AdvertisementItem adItem}) {
    switch (adItem.type) {
      case AdvertisementType.reward:
        _loadRewardAd(adItem, (ad) => ad.show());
        break;
      case AdvertisementType.interstitial:
        _loadInterstitialAd(adItem, (ad) => ad.show());
        break;
      case AdvertisementType.splash:
        _loadSplashAd(adItem);
        break;
      case AdvertisementType.banner:
        _loadBannerAd(adItem, (ad) => ad.show());
        break;
      default:
        break;
    }
  }

  @override
  void hideAd(AdvertisementItem adItem) {
    if (_ads.containsKey(adItem.id)) {
      var ad = _ads[adItem.id];
      switch (adItem.type) {
        case AdvertisementType.banner:
          (ad as BannerAd).destroy();
          break;
        case AdvertisementType.native:
          break;
        case AdvertisementType.reward:
          (ad as RewardAd).destroy();
          break;
        case AdvertisementType.interstitial:
          (ad as InterstitialAd).destroy();
          break;
        case AdvertisementType.roll:
          break;
        case AdvertisementType.splash:
          (ad as SplashAd).destroy();
          break;
        default:
          break;
      }
      _ads.remove(adItem.id);
    }
  }

  @override
  bool get isSupported => DeviceInfo.instance.android != null && (DeviceInfo.instance.android!.manufacturer ?? '').toUpperCase() == 'HUAWEI';

  @override
  void hideLoadedAd({required loadedAd, required AdvertisementType type}) {
    switch (type) {
      case AdvertisementType.banner:
        (loadedAd as BannerAd).destroy();
        break;
      case AdvertisementType.native:
        break;
      case AdvertisementType.reward:
        (loadedAd as RewardAd).destroy();
        break;
      case AdvertisementType.interstitial:
        (loadedAd as InterstitialAd).destroy();
        break;
      case AdvertisementType.roll:
        break;
      case AdvertisementType.splash:
        (loadedAd as SplashAd).destroy();
        break;
      default:
        break;
    }
  }

  @override
  void showLoadedAd({required loadedAd, required AdvertisementType type}) {
    switch (type) {
      case AdvertisementType.reward:
        loadedAd.show();
        break;
      case AdvertisementType.interstitial:
        loadedAd.show();
        break;
      case AdvertisementType.banner:
        loadedAd.show();
        break;
      default:
        break;
    }
  }
}
