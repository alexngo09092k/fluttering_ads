part of '../google_advertisement.dart';

extension FluidEx on GoogleAdvertisement {
  FluidAdManagerBannerAd _loadFluidAd(
    AdvertisementItem adItem, [
    Function(FluidAdManagerBannerAd)? onAd,
    Function(Ad)? onLoadedAd,
    Function(LoadAdError error)? onAdFailedToLoad,
  ]) {
    _ads[adItem.id] = FluidAdManagerBannerAd(
      adUnitId: adItem.id,
      request: const AdManagerAdRequest(nonPersonalizedAds: true),
      listener: AdManagerBannerAdListener(
        onAdLoaded: (Ad ad) {
          _ads[adItem.id] = ad;
          Debug.log('FluidAd $ad loaded: ${ad.responseInfo}');
          if (onLoadedAd != null) onLoadedAd(ad);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          Debug.log('Fuild Ad failedToLoad: $error');
          if (onAdFailedToLoad != null) onAdFailedToLoad(error);
          ad.dispose();
        },
        onAdOpened: (Ad ad) => Debug.log('onAdOpened.'),
        onAdClosed: (Ad ad) => Debug.log('onAdClosed.'),
      ),
    )..load();
    if (onAd != null) {
      onAd(_ads[adItem.id] as FluidAdManagerBannerAd);
    }
    return _ads[adItem.id] as FluidAdManagerBannerAd;
  }
}
