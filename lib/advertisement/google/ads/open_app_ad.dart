part of '../google_advertisement.dart';

extension OpenAppEx on GoogleAdvertisement {
  _loadOpenAppAd(
    AdvertisementItem adItem, [
    Function(AppOpenAd)? onAd,
    Function(AppOpenAd)? onLoadedAd,
    Function(LoadAdError error)? onAdFailedToLoad,
  ]) {
    AppOpenAd.load(
      adUnitId: adItem.id,
      request: const AdManagerAdRequest(nonPersonalizedAds: true),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (AppOpenAd ad) {
          _ads[adItem.id] = ad;
          Debug.log('app open add loaded');
          // Keep a reference to the ad so you can show it later.
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (AppOpenAd ad) =>
                Debug.log('$ad onAdShowedFullScreenContent.'),
            onAdDismissedFullScreenContent: (AppOpenAd ad) {
              Debug.log('$ad onAdDismissedFullScreenContent.');
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (AppOpenAd ad, AdError error) {
              Debug.log('$ad onAdFailedToShowFullScreenContent: $error');
              ad.dispose();
            },
            onAdImpression: (AppOpenAd ad) =>
                Debug.log('$ad impression occurred.'),
          );
          if (onLoadedAd != null) onLoadedAd(ad);
          if (onAd != null) {
            onAd(ad);
          }
        },
        onAdFailedToLoad: (LoadAdError error) {
          Debug.log('OpenAppAd failed to load: $error');
          if (onAdFailedToLoad != null) onAdFailedToLoad(error);
        },
      ),
    );
  }
}
