part of '../google_advertisement.dart';

extension BannerEx on GoogleAdvertisement {
  BannerAd _loadBannerAd(
    AdvertisementItem adItem, [
    Function(BannerAd)? onAd,
    Function(Ad)? onLoadedAd,
    Function(LoadAdError error)? onAdFailedToLoad,
    AdSize? adSize,
  ]) {
    _ads[adItem.id] = BannerAd(
      adUnitId: adItem.id,
      size: adSize ?? AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          _ads[adItem.id] = ad;
          Debug.log('Banner $ad loaded: ${ad.responseInfo}');
          if (onLoadedAd != null) onLoadedAd(ad);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          Debug.log('Banner failedToLoad: $error');
          if (onAdFailedToLoad != null) onAdFailedToLoad(error);
          ad.dispose();
        },
      ),
      request: const AdManagerAdRequest(nonPersonalizedAds: true),
    )..load();
    if (onAd != null) {
      onAd(_ads[adItem.id] as BannerAd);
    }
    return _ads[adItem.id] as BannerAd;
  }
}
