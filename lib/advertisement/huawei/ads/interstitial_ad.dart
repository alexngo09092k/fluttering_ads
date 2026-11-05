part of '../huawei_advertisement.dart';

extension InterstitialAdEx on HuaweiAdvertisement {
  InterstitialAd _loadInterstitialAd(
    AdvertisementItem adItem, [
    Function(InterstitialAd)? onAd,
    Function(InterstitialAd?)? onLoadedAd,
    Function(int? error)? onAdFailedToLoad,
  ]) {
    final ad = InterstitialAd(
      adSlotId: adItem.id,
      adParam: AdParam(),
      listener: (AdEvent event, {int? errorCode}) {
        Debug.log('loadInterstitialAd $event');
        switch (event) {
          //  case AdEvent.closed:
          //  case AdEvent.leave:
          case AdEvent.failed:
            if (onAdFailedToLoad != null) onAdFailedToLoad(errorCode);
            _ads.remove(adItem.id);
            break;
          //  case AdEvent.clicked:
          //  case AdEvent.impression:
          //  case AdEvent.disliked:
          case AdEvent.loaded:
            // Only call onAd (usually show) AFTER the ad is fully loaded.
            // Calling show() before loaded causes countdown stuck at 1 on Huawei.
            if (onLoadedAd != null) onLoadedAd(_ads[adItem.id]);
            // Chỉ gọi onAd (thường là show) SAU KHI loaded
            if (onAd != null) onAd(_ads[adItem.id]!);
            break;
          case AdEvent.opened:
            break;
          case AdEvent.closed:
          case AdEvent.leave:
            // Must destroy when closed, otherwise ad state gets stuck
            try {
              (_ads[adItem.id] as InterstitialAd?)?.destroy();
            } catch (_) {}
            _ads.remove(adItem.id);
            break;
          default:
            break;
        }
      },
    )..loadAd();

    _ads[adItem.id] = ad;
    return ad;
  }
}
