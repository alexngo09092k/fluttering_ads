part of '../huawei_advertisement.dart';

extension InterstitialAdEx on HuaweiAdvertisement {
  static const int _maxRetry = 2;

  InterstitialAd _loadInterstitialAd(
    AdvertisementItem adItem, [
    Function(InterstitialAd)? onAd,
    Function(InterstitialAd?)? onLoadedAd,
    Function(int? error)? onAdFailedToLoad,
    int retry = 0,
  ]) {
    final existing = _ads[adItem.id];
    if (existing is InterstitialAd && _loadedFlags[adItem.id] == true) {
      if (onLoadedAd != null) onLoadedAd(existing);
      if (onAd != null) onAd(existing);
      return existing;
    }

    final ad = InterstitialAd(
      adSlotId: adItem.id,
      adParam: AdParam(),
      listener: (AdEvent event, {int? errorCode}) {
        Debug.log('Huawei InterstitialAd $event code=$errorCode');
        switch (event) {
          case AdEvent.failed:
            _loadedFlags.remove(adItem.id);
            try {
              (_ads[adItem.id] as InterstitialAd?)?.destroy();
            } catch (_) {}
            _ads.remove(adItem.id);
            if (retry < _maxRetry) {
              Debug.log('Huawei InterstitialAd retry ${retry + 1}/$_maxRetry');
              Future.delayed(Duration(milliseconds: 400 * (retry + 1)), () {
                _loadInterstitialAd(adItem, onAd, onLoadedAd, onAdFailedToLoad, retry + 1);
              });
            } else {
              if (onAdFailedToLoad != null) onAdFailedToLoad(errorCode);
            }
            break;
          case AdEvent.loaded:
            // Only call onAd (usually show) AFTER loaded.
            _loadedFlags[adItem.id] = true;
            if (onLoadedAd != null) onLoadedAd(_ads[adItem.id]);
            if (onAd != null) onAd(_ads[adItem.id]!);
            break;
          case AdEvent.opened:
            break;
          case AdEvent.closed:
          case AdEvent.leave:
            _loadedFlags.remove(adItem.id);
            try {
              (_ads[adItem.id] as InterstitialAd?)?.destroy();
            } catch (_) {}
            _ads.remove(adItem.id);
            Future.delayed(const Duration(milliseconds: 600), () {
              if (!_ads.containsKey(adItem.id)) {
                _loadInterstitialAd(adItem, null, null, null, 0);
              }
            });
            break;
          default:
            break;
        }
      },
    )..loadAd();

    _ads[adItem.id] = ad;
    _loadedFlags[adItem.id] = false;
    return ad;
  }
}
