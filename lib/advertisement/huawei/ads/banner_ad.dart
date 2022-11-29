part of '../huawei_advertisement.dart';

extension BannerAdEx on HuaweiAdvertisement {
  BannerAd _loadBannerAd(
    AdvertisementItem adItem, [
    Function(BannerAd)? onAd,
    Function(BannerAd?)? onLoadedAd,
    Function(int? error)? onAdFailedToLoad,
  ]) {
    _ads[adItem.id] = BannerAd(
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
      },
    )..loadAd();
    if (onAd != null && _ads[adItem.id] != null) {
      onAd(_ads[adItem.id]!);
    }
    return _ads[adItem.id]!;
  }
}
