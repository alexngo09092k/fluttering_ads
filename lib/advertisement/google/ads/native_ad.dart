part of '../google_advertisement.dart';

extension NativeEx on GoogleAdvertisement {
  NativeAd _loadNativeAd(
    AdvertisementItem adItem, [
    Function(NativeAd)? onAd,
    Function(Ad)? onLoadedAd,
    Function(LoadAdError error)? onAdFailedToLoad,
  ]) {
    _ads[adItem.id] = NativeAd(
      adUnitId: adItem.id,
      factoryId: 'listTile',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          _ads[adItem.id] = ad;
          Debug.log('Native $ad loaded: ${ad.responseInfo}');
          if (onLoadedAd != null) onLoadedAd(ad);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          Debug.log('Native failedToLoad: $error');
          if (onAdFailedToLoad != null) onAdFailedToLoad(error);
          ad.dispose();
        },
      ),
      request: const AdManagerAdRequest(nonPersonalizedAds: true),
    )..load();
    if (onAd != null) {
      onAd(_ads[adItem.id] as NativeAd);
    }
    return _ads[adItem.id] as NativeAd;
  }
}
