part of '../huawei_advertisement.dart';

extension RewardAdEx on HuaweiAdvertisement {
  RewardAd _loadRewardAd(
    AdvertisementItem adItem, [
    Function(RewardAd)? onAd,
    Function(RewardAd?)? onLoadedAd,
    Function(int? error)? onAdFailedToLoad,
  ]) {
    final ad = RewardAd(
      listener: (RewardAdEvent? event, {Reward? reward, int? errorCode}) {
        Debug.log('loadRewardAd $event');
        switch (event) {
          // case RewardAdEvent.leftApp:
          // case RewardAdEvent.closed:
          case RewardAdEvent.failedToLoad:
            if (onAdFailedToLoad != null) onAdFailedToLoad(errorCode);
            _ads.remove(adItem.id);
            break;
          // case RewardAdEvent.started:
          // case RewardAdEvent.completed:
          // case RewardAdEvent.rewarded:
          case RewardAdEvent.loaded:
            // Only call onAd (usually show) AFTER the ad is fully loaded.
            if (onLoadedAd != null) onLoadedAd(_ads[adItem.id]);
            if (onAd != null) onAd(_ads[adItem.id]!);
            break;
          case RewardAdEvent.opened:
            break;
          case RewardAdEvent.closed:
          case RewardAdEvent.leftApp:
            // Must destroy when closed to avoid stuck state
            try {
              (_ads[adItem.id] as RewardAd?)?.destroy();
            } catch (_) {}
            _ads.remove(adItem.id);
            break;
          case RewardAdEvent.rewarded:
          case RewardAdEvent.completed:
          case RewardAdEvent.started:
            break;
          default:
            break;
        }
      },
    )..loadAd(
        adSlotId: adItem.id,
        adParam: AdParam(),
      );

    _ads[adItem.id] = ad;
    return ad;
  }
}
