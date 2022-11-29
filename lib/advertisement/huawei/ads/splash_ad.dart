part of '../huawei_advertisement.dart';

extension SplashAdEx on HuaweiAdvertisement {
  SplashAd _loadSplashAd(
    AdvertisementItem adItem, [
    Function(SplashAd)? onAd,
    Function(dynamic)? onLoadedAd,
    Function(int? error)? onAdFailedToLoad,
  ]) {
    _ads[adItem.id] = SplashAd(
        adType: SplashAdType.above,
        ownerText: 'CUSTOM OWNER',
        loadListener: (SplashAdLoadEvent event, {int? errorCode}) {
          Debug.log('loadSplashAd $event');
          switch (event) {
            case SplashAdLoadEvent.failedToLoad:
              if (onAdFailedToLoad != null) onAdFailedToLoad(errorCode);
              break;
            // case SplashAdLoadEvent.dismissed:
            // break;
            case SplashAdLoadEvent.loaded:
              if (onLoadedAd != null) onLoadedAd(_ads[adItem.id]);
              break;
            default:
          }
        })
      ..loadAd(
        adSlotId: adItem.id,
        orientation: SplashAdOrientation.portrait,
        adParam: AdParam(),
        topMargin: 50,
      );

    if (onAd != null) {
      onAd(_ads[adItem.id]);
    }
    return _ads[adItem.id];
  }
}
