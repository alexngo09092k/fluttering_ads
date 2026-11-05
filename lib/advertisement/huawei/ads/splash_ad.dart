part of '../huawei_advertisement.dart';

extension SplashAdEx on HuaweiAdvertisement {
  SplashAd _loadSplashAd(
    AdvertisementItem adItem, [
    Function(SplashAd)? onAd,
    Function(dynamic)? onLoadedAd,
    Function(int? error)? onAdFailedToLoad,
  ]) {
    final ad = SplashAd(
      adType: SplashAdType.above,
      ownerText: 'CUSTOM OWNER',
      loadListener: (SplashAdLoadEvent event, {int? errorCode}) {
        Debug.log('loadSplashAd $event');
        switch (event) {
          case SplashAdLoadEvent.failedToLoad:
            if (onAdFailedToLoad != null) onAdFailedToLoad(errorCode);
            _ads.remove(adItem.id);
            break;
          // case SplashAdLoadEvent.dismissed:
          // break;
          case SplashAdLoadEvent.loaded:
            if (onLoadedAd != null) onLoadedAd(_ads[adItem.id]);
            if (onAd != null) onAd(_ads[adItem.id]!);
            break;
          case SplashAdLoadEvent.dismissed:
            try {
              (_ads[adItem.id] as SplashAd?)?.destroy();
            } catch (_) {}
            _ads.remove(adItem.id);
            break;
          default:
            break;
        }
      },
    )..loadAd(
        adSlotId: adItem.id,
        orientation: SplashAdOrientation.portrait,
        adParam: AdParam(),
      );

    _ads[adItem.id] = ad;
    return ad;
  }
}
