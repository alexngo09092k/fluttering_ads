part of '../google_advertisement.dart';

extension RewardEx on GoogleAdvertisement {
  void _loadRewardAd(
    AdvertisementItem adItem, [
    Function(RewardedAd)? onAd,
    Function(RewardedAd)? onLoadedAd,
    Function(LoadAdError error)? onAdFailedToLoad,
  ]) {
    RewardedAd.load(
      adUnitId: adItem.id,
      request: const AdManagerAdRequest(nonPersonalizedAds: true),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _ads[adItem.id] = ad;
          Debug.log('$ad loaded.');
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (RewardedAd ad) => Debug.log('$ad onAdShowedFullScreenContent.'),
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              Debug.log('$ad onAdDismissedFullScreenContent.');
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              Debug.log('$ad onAdFailedToShowFullScreenContent: $error');
              ad.dispose();
            },
            onAdImpression: (RewardedAd ad) => Debug.log('$ad impression occurred.'),
          );
          if (onLoadedAd != null) onLoadedAd(ad);
          if (onAd != null) onAd(ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          Debug.log('RewardedAd failed to load: $error');
          if (onAdFailedToLoad != null) onAdFailedToLoad(error);
        },
      ),
    );
  }
}
