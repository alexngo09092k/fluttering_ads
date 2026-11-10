part of '../huawei_advertisement.dart';

extension BannerAdEx on HuaweiAdvertisement {
  BannerAdSize resolveBannerSize(AdvertisementItem adItem) {
    final h = adItem.height;
    final w = adItem.width;
    if (h != null) {
      if (h <= 50) return BannerAdSize.s320x50;
      if (h <= 57) return BannerAdSize.s360x57;
      if (h <= 60) return BannerAdSize.s468x60;
      if (h <= 90) return BannerAdSize.s728x90;
      if (h <= 100) return BannerAdSize.s320x100;
      if (h <= 250) return BannerAdSize.s300x250;
    }
    if (w != null && w >= 700) return BannerAdSize.s728x90;
    return BannerAdSize.s360x57;
  }

  /// Programmatic banner (overlay via loadAd + show). Not a Widget.
  BannerAd _loadBannerAd(
    AdvertisementItem adItem, [
    Function(BannerAd)? onAd,
    Function(BannerAd?)? onLoadedAd,
    Function(int? error)? onAdFailedToLoad,
  ]) {
    final ad = BannerAd(
      adSlotId: adItem.id,
      size: resolveBannerSize(adItem),
      adParam: AdParam(),
      bannerRefreshTime: 30000,
      listener: (AdEvent event, {int? errorCode}) {
        Debug.log('Huawei BannerAd $event code=$errorCode');
        switch (event) {
          case AdEvent.failed:
            if (onAdFailedToLoad != null) onAdFailedToLoad(errorCode);
            try {
              (_ads[adItem.id] as BannerAd?)?.destroy();
            } catch (_) {}
            _ads.remove(adItem.id);
            break;
          case AdEvent.loaded:
            if (onLoadedAd != null) onLoadedAd(_ads[adItem.id]);
            if (onAd != null) onAd(_ads[adItem.id]!);
            break;
          case AdEvent.opened:
            break;
          case AdEvent.closed:
          case AdEvent.leave:
            try {
              (_ads[adItem.id] as BannerAd?)?.destroy();
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

  /// In-layout banner Widget for AdView / createAdWidget.
  /// Huawei requires [BannerView], not [BannerAd] (BannerAd is not a Widget).
  Widget _buildBannerView(
    AdvertisementItem adItem, {
    Function(dynamic)? onLoadedAd,
    Function(dynamic error)? onAdFailedToLoad,
  }) {
    final size = resolveBannerSize(adItem);
    final controller = BannerViewController(
      listener: (AdEvent event, {int? errorCode}) {
        Debug.log('Huawei BannerView $event code=$errorCode');
        switch (event) {
          case AdEvent.failed:
            if (onAdFailedToLoad != null) onAdFailedToLoad(errorCode);
            break;
          case AdEvent.loaded:
            if (onLoadedAd != null) onLoadedAd(adItem.id);
            break;
          default:
            break;
        }
      },
    );

    return BannerView(
      adSlotId: adItem.id,
      size: size,
      loadOnStart: true,
      refreshDuration: const Duration(seconds: 30),
      adParam: AdParam(),
      controller: controller,
    );
  }
}
