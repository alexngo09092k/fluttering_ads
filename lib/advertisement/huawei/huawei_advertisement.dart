import 'dart:async';

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
  /// True when the ad instance for [id] has fired loaded and is ready to show.
  final Map<String, bool> _loadedFlags = {};

  InstreamAdViewController? _instreamAdViewController;
  NativeAdController? _nativeAdController;

  /// Optional global reward callback set by host app.
  void Function(AdvertisementItem item, Reward? reward)? _onRewardedGlobal;

  void setOnRewarded(void Function(AdvertisementItem item, Reward? reward)? cb) {
    _onRewardedGlobal = cb;
  }

  @override
  Widget createAdWidget({
    required AdvertisementItem adItem,
    Function(dynamic)? onLoadedAd,
    Function(dynamic error)? onAdFailedToLoad,
  }) {
    if (!isSupported) {
      if (onAdFailedToLoad != null) onAdFailedToLoad(ErrorDescription("This device not support Huawei Ads"));
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
        case AdvertisementType.native:
          return Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: _loadNativeAd(
              adItem,
              null,
              onLoadedAd,
              onAdFailedToLoad,
              isInfinity ? NativeAdType.full : (height < 100 ? NativeAdType.small : NativeAdType.banner),
            ),
          );
        case AdvertisementType.roll:
          return FutureBuilder<InstreamAdView?>(
            future: _loadInstreamAdView(
              adItem,
              null,
              onLoadedAd,
              onAdFailedToLoad,
            ),
            builder: (_, snapshot) => Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              child: snapshot.data ?? const SizedBox(),
            ),
          );
        case AdvertisementType.banner:
          // BannerView is a Widget; BannerAd is NOT (use BannerAd only for overlay show()).
          return Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: _buildBannerView(
              adItem,
              onLoadedAd: onLoadedAd,
              onAdFailedToLoad: onAdFailedToLoad,
            ),
          );
        default:
          if (onAdFailedToLoad != null) onAdFailedToLoad(ErrorDescription('Can not found ads widget'));
          return const SizedBox();
      }
    });
  }

  @override
  void loadAd({
    required AdvertisementItem adItem,
    Function(dynamic)? onAd,
    Function(dynamic)? onLoadedAd,
    Function(dynamic error)? onAdFailedToLoad,
  }) {
    if (!isSupported) {
      if (onAdFailedToLoad != null) onAdFailedToLoad(ErrorDescription("This device not support Huawei Ads"));
      return;
    }
    switch (adItem.type) {
      case AdvertisementType.banner:
        _loadBannerAd(adItem, onAd as Function(BannerAd)?, onLoadedAd, onAdFailedToLoad);
        break;
      case AdvertisementType.native:
        _loadNativeAd(adItem, onAd as Function(NativeAd)?, onLoadedAd, onAdFailedToLoad);
        break;
      case AdvertisementType.reward:
        _loadRewardAd(adItem, onAd as Function(RewardAd)?, onLoadedAd, onAdFailedToLoad);
        break;
      case AdvertisementType.interstitial:
        _loadInterstitialAd(adItem, onAd as Function(InterstitialAd)?, onLoadedAd, onAdFailedToLoad);
        break;
      case AdvertisementType.roll:
        _loadInstreamAdView(adItem, onAd, onLoadedAd, onAdFailedToLoad);
        break;
      case AdvertisementType.splash:
        // Never load/show splash via generic loadAd (restore / handle).
        // Splash is cold-start only — see showSplashAndWait + willSplash.
        Debug.log('Huawei loadAd(splash) ignored — use showSplashAndWait only at cold start');
        break;
      default:
        break;
    }
  }

  @override
  void showAd({required AdvertisementItem adItem, Function(dynamic error)? onAdFailedToLoad}) {
    if (!isSupported) {
      if (onAdFailedToLoad != null) onAdFailedToLoad(ErrorDescription("This device not support Huawei Ads"));
      return;
    }
    switch (adItem.type) {
      case AdvertisementType.reward:
        // Load (or reuse), then show only when loaded.
        _loadRewardAd(adItem, (ad) => ad.show(), null, onAdFailedToLoad);
        break;
      case AdvertisementType.interstitial:
        _loadInterstitialAd(adItem, (ad) => ad.show(), null, onAdFailedToLoad);
        break;
      case AdvertisementType.splash:
        // Do NOT show splash via generic showAd — only via showSplashAndWait
        // during willSplash / cold start (AppGallery rule 5.2).
        Debug.log('Huawei showAd(splash) ignored — use showSplashAndWait only at cold start');
        break;
      case AdvertisementType.banner:
        _loadBannerAd(adItem, (ad) => ad.show(), null, onAdFailedToLoad);
        break;
      default:
        break;
    }
  }

  /// Shows the splash ad and completes when it is dismissed, fails, or times out.
  /// Must only be called from cold-start (willSplash). Never from restore/handleAd.
  Future<void> showSplashAndWait(
    AdvertisementItem adItem, {
    Duration timeout = const Duration(seconds: 8),
  }) async {
    if (!isSupported) return;
    if (adItem.type != AdvertisementType.splash) return;

    final completer = Completer<void>();
    Timer? timer;
    timer = Timer(timeout, () {
      if (!completer.isCompleted) {
        Debug.log('Huawei SplashAd timed out after ${timeout.inSeconds}s');
        try {
          (_ads[adItem.id] as SplashAd?)?.destroy();
        } catch (_) {}
        _ads.remove(adItem.id);
        completer.complete();
      }
    });

    _loadSplashAd(
      adItem,
      null,
      null,
      (error) {
        Debug.log('Huawei SplashAd failed: $error');
        if (!completer.isCompleted) completer.complete();
      },
      () {
        if (!completer.isCompleted) completer.complete();
      },
    );

    await completer.future;
    timer.cancel();
  }

  @override
  void hideAd(AdvertisementItem adItem) {
    if (!isSupported) return;

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
      _loadedFlags.remove(adItem.id);
    }
  }

  bool _isSupported = CurrentPlatform.instance.isHuawei;

  @override
  bool get isSupported => _isSupported;

  @override
  void hideLoadedAd({required loadedAd, required AdvertisementType type}) {
    if (!isSupported) return;

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
    if (!isSupported) return;

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

  @override
  Future<bool> initial() async {
    try {
      _isSupported = await CurrentPlatform.instance.isHmsAvailable;
      Debug.log('HuaweiAdvertisement is supported $_isSupported');
      return true;
    } catch (error) {
      Debug.log("HuaweiAdvertisement initial error $error");
    }
    return false;
  }
}
