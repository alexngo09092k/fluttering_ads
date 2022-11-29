part of '../google_advertisement.dart';

extension InterstitialEx on GoogleAdvertisement {
  void _loadInterstitialAd(
    AdvertisementItem adItem, [
    Function(InterstitialAd)? onAd,
    Function(InterstitialAd)? onLoadedAd,
    Function(LoadAdError error)? onAdFailedToLoad,
  ]) {
    InterstitialAd.load(
      adUnitId: adItem.id,
      request: const AdManagerAdRequest(nonPersonalizedAds: true),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _ads[adItem.id] = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (InterstitialAd ad) => Debug.log('$ad onAdShowedFullScreenContent.'),
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              Debug.log('$ad onAdDismissedFullScreenContent.');
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              Debug.log('$ad onAdFailedToShowFullScreenContent: $error');
              ad.dispose();
            },
            onAdImpression: (InterstitialAd ad) => Debug.log('$ad impression occurred.'),
          );
          if (onLoadedAd != null) onLoadedAd(ad);
          if (onAd != null) onAd(ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          Debug.log('InterstitialAd failed to load: $error');
          if (onAdFailedToLoad != null) onAdFailedToLoad(error);
        },
      ),
    );
  }
}
