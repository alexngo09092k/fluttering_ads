part of '../huawei_advertisement.dart';

extension SplashAdEx on HuaweiAdvertisement {
  /// Loads and displays a Huawei SplashAd.
  ///
  /// IMPORTANT: Huawei SplashAd.loadAd() both loads AND displays the ad.
  /// It must only be called during cold-start / willSplash — never from
  /// restore() or handleAd(), otherwise AppGallery rejects with
  /// "When your app displays an ad, it does not close" (rule 5.2).
  ///
  /// [onFinished] is called when the ad is dismissed, fails to load, or
  /// is otherwise finished so the host can continue the splash flow.
  SplashAd _loadSplashAd(
    AdvertisementItem adItem, [
    Function(SplashAd)? onAd,
    Function(dynamic)? onLoadedAd,
    Function(int? error)? onAdFailedToLoad,
    VoidCallback? onFinished,
  ]) {
    // Avoid stacking multiple splash instances for the same slot.
    try {
      (_ads[adItem.id] as SplashAd?)?.destroy();
    } catch (_) {}
    _ads.remove(adItem.id);

    var finished = false;
    void finish() {
      if (finished) return;
      finished = true;
      onFinished?.call();
    }

    final ad = SplashAd(
      adType: SplashAdType.above,
      ownerText: '',
      loadListener: (SplashAdLoadEvent event, {int? errorCode}) {
        Debug.log('Huawei SplashAd $event code=$errorCode');
        switch (event) {
          case SplashAdLoadEvent.failedToLoad:
            if (onAdFailedToLoad != null) onAdFailedToLoad(errorCode);
            try {
              (_ads[adItem.id] as SplashAd?)?.destroy();
            } catch (_) {}
            _ads.remove(adItem.id);
            finish();
            break;
          case SplashAdLoadEvent.loaded:
            if (onLoadedAd != null) onLoadedAd(_ads[adItem.id]);
            if (onAd != null) onAd(_ads[adItem.id]!);
            // Do NOT finish here — wait for dismissed so the ad is fully closed.
            break;
          case SplashAdLoadEvent.dismissed:
            try {
              (_ads[adItem.id] as SplashAd?)?.destroy();
            } catch (_) {}
            _ads.remove(adItem.id);
            finish();
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
