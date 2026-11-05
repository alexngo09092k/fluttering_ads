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
            break;
          // case RewardAdEvent.started:
          // case RewardAdEvent.completed:
          // case RewardAdEvent.rewarded:
          case RewardAdEvent.loaded:
            if (onLoadedAd != null) onLoadedAd(_ads[adItem.id]);
            if (onAd != null) onAd(_ads[adItem.id]!);
            break;
          case RewardAdEvent.closed:
            try {
              (_ads[adItem.id] as RewardAd?)?.destroy();
            } catch (_) {}
            _ads.remove(adItem.id);
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
