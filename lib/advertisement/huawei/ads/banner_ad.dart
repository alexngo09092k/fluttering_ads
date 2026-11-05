part of '../huawei_advertisement.dart';

extension BannerAdEx on HuaweiAdvertisement {
  BannerAd _loadBannerAd(
    AdvertisementItem adItem, [
    Function(BannerAd)? onAd,
    Function(BannerAd?)? onLoadedAd,
    Function(int? error)? onAdFailedToLoad,
  ]) {
    final ad = BannerAd(
      adSlotId: adItem.id,
      size: BannerAdSize.s468x60,
      adParam: AdParam(),
      bannerRefreshTime: 5000,
      listener: (AdEvent event, {int? errorCode}) {
        Debug.log('loadBannerAd $event');
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
}
