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

class GoogleAdvertisement extends BaseAdvertisement {
  @override
  AdvertisementProvider get provider => AdvertisementProvider.google;

  final Map<String, Ad> _ads = {};

  @override
  Widget createAdWidget({
    required AdvertisementItem adItem,
    Function(dynamic)? onLoadedAd,
    Function(dynamic error)? onAdFailedToLoad,
  }) {
    if (!isSupported) {
      if (onAdFailedToLoad != null) onAdFailedToLoad(ErrorDescription("This device not support Google Mobile Ads"));
      return const SizedBox();
    }

    return LayoutBuilder(builder: (context, boxConstraints) {
      final double width = adItem.width ?? boxConstraints.maxWidth;
      final double height = adItem.height ?? boxConstraints.maxHeight;
      final isInfinity = width == double.infinity || height == double.infinity;
      final isZero = width == 0 || height == 0;
      Debug.log("CREATE AD WIDGET SIZE $width, $height");

      if (isZero) return const SizedBox();

      switch (adItem.type) {
        case AdvertisementType.banner:
          return Container(
            alignment: Alignment.center,
            width: width,
            height: height,
            child: AdWidget(
              ad: _loadBannerAd(
                adItem,
                null,
                onLoadedAd,
                onAdFailedToLoad,
                isInfinity ? AdSize.fluid : AdSize(width: width.toInt(), height: height.toInt()),
              ),
            ),
          );

        case AdvertisementType.fluid:
          return Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: AdWidget(
              ad: _loadFluidAd(adItem, null, onLoadedAd, onAdFailedToLoad),
            ),
          );
        case AdvertisementType.native:
          return Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: AdWidget(
              ad: _loadNativeAd(adItem, null, onLoadedAd, onAdFailedToLoad),
            ),
          );
        default:
          return const SizedBox();
      }
    });
  }

  @override
  void loadAd({
    required AdvertisementItem adItem,
    Function(dynamic)? onAd,
    Function(Ad)? onLoadedAd,
    Function(dynamic error)? onAdFailedToLoad,
    AdSize? adSize,
  }) {
    if (!isSupported) {
      if (onAdFailedToLoad != null) onAdFailedToLoad(ErrorDescription("This device not support Google Mobile Ads"));
      return;
    }

    switch (adItem.type) {
      case AdvertisementType.banner:
        _loadBannerAd(adItem, onAd, onLoadedAd, onAdFailedToLoad, adSize);
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
  void showAd({required AdvertisementItem adItem, Function(dynamic error)? onAdFailedToLoad}) {
    if (!isSupported) {
      if (onAdFailedToLoad != null) onAdFailedToLoad(ErrorDescription("This device not support Google Mobile Ads"));
      return;
    }

    return loadAd(
      adItem: adItem,
      onAdFailedToLoad: onAdFailedToLoad,
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

  bool _isSupported = CurrentPlatform.instance.isMobile;

  @override
  bool get isSupported => _isSupported;

  @override
  void hideAd(AdvertisementItem adItem) {
    if (!isSupported) return;

    if (_ads.containsKey(adItem.id)) {
      _ads[adItem.id]!.dispose();
      _ads.remove(adItem.id);
    }
  }

  @override
  void showLoadedAd({required loadedAd, required AdvertisementType type}) {
    if (!isSupported) return;

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
    if (!isSupported) return;

    loadedAd!.dispose();
  }

  @override
  Future<bool> initial() async {
    try {
      _isSupported = await CurrentPlatform.instance.isGmsAvailable;
      Debug.log('GoogleAdvertisement is supported $_isSupported');
      return true;
    }catch(error) {
      Debug.log("GoogleAdvertisement initial error $error");
    }
    return false;
  }
}
