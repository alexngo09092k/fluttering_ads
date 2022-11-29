part of '../huawei_advertisement.dart';

extension InterstitialAdEx on HuaweiAdvertisement {
  InterstitialAd _loadInterstitialAd(
    AdvertisementItem adItem, [
    Function(InterstitialAd)? onAd,
    Function(InterstitialAd?)? onLoadedAd,
    Function(int? error)? onAdFailedToLoad,
  ]) {
    _ads[adItem.id] = InterstitialAd(
        adSlotId: adItem.id,
        adParam: AdParam(),
        listener: (AdEvent event, {int? errorCode}) {
          Debug.log('loadInterstitialAd $event');
          switch (event) {
            //  case AdEvent.closed:
            //  case AdEvent.leave:
            case AdEvent.failed:
              if (onAdFailedToLoad != null) onAdFailedToLoad(errorCode);
              break;
            //  case AdEvent.clicked:
            //  case AdEvent.impression:
            //  case AdEvent.disliked:
            case AdEvent.loaded:
            case AdEvent.opened:
              if (onLoadedAd != null) onLoadedAd(_ads[adItem.id]);
              break;
            default:
          }
        })
      ..loadAd();

    if (onAd != null) {
      onAd(_ads[adItem.id]);
    }
    return _ads[adItem.id];
  }
}
