part of '../huawei_advertisement.dart';

extension RewardAdEx on HuaweiAdvertisement {
  RewardAd _loadRewardAd(
    AdvertisementItem adItem, [
    Function(RewardAd)? onAd,
    Function(RewardAd?)? onLoadedAd,
    Function(int? error)? onAdFailedToLoad,
  ]) {
    _ads[adItem.id] = RewardAd(listener: (RewardAdEvent? event, {Reward? reward, int? errorCode}) {
      Debug.log('loadRewardAd $event');
      switch (event) {
        // case RewardAdEvent.leftApp:
        // case RewardAdEvent.closed:
        case RewardAdEvent.failedToLoad:
          if (onAdFailedToLoad != null) onAdFailedToLoad(errorCode);
          break;
        // case RewardAdEvent.started:
        // case RewardAdEvent.completed:
        // case RewardAdEvent.rewarded:
        case RewardAdEvent.loaded:
        case RewardAdEvent.opened:
          if (onLoadedAd != null) onLoadedAd(_ads[adItem.id]);
          break;
        default:
      }
    })
      ..loadAd(
        adSlotId: adItem.id,
        adParam: AdParam(),
      );

    if (onAd != null) {
      onAd(_ads[adItem.id]);
    }
    return _ads[adItem.id];
  }
}
