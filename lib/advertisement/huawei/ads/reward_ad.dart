part of '../huawei_advertisement.dart';

extension RewardAdEx on HuaweiAdvertisement {
  static const int _maxRetry = 2;

  RewardAd _loadRewardAd(
    AdvertisementItem adItem, [
    Function(RewardAd)? onAd,
    Function(RewardAd?)? onLoadedAd,
    Function(int? error)? onAdFailedToLoad,
    Function(Reward?)? onRewarded,
    int retry = 0,
  ]) {
    final existing = _ads[adItem.id];
    if (existing is RewardAd && _loadedFlags[adItem.id] == true) {
      if (onLoadedAd != null) onLoadedAd(existing);
      if (onAd != null) onAd(existing);
      return existing;
    }

    final ad = RewardAd(
      listener: (RewardAdEvent? event, {Reward? reward, int? errorCode}) {
        Debug.log('Huawei RewardAd $event code=$errorCode');
        switch (event) {
          case RewardAdEvent.failedToLoad:
            _loadedFlags.remove(adItem.id);
            try {
              (_ads[adItem.id] as RewardAd?)?.destroy();
            } catch (_) {}
            _ads.remove(adItem.id);
            if (retry < _maxRetry) {
              Debug.log('Huawei RewardAd retry ${retry + 1}/$_maxRetry');
              Future.delayed(Duration(milliseconds: 400 * (retry + 1)), () {
                _loadRewardAd(adItem, onAd, onLoadedAd, onAdFailedToLoad, onRewarded, retry + 1);
              });
            } else {
              if (onAdFailedToLoad != null) onAdFailedToLoad(errorCode);
            }
            break;
          case RewardAdEvent.loaded:
            _loadedFlags[adItem.id] = true;
            if (onLoadedAd != null) onLoadedAd(_ads[adItem.id]);
            // Only show AFTER loaded — prevents countdown stuck at 1.
            if (onAd != null) onAd(_ads[adItem.id]!);
            break;
          case RewardAdEvent.opened:
            break;
          case RewardAdEvent.rewarded:
            if (onRewarded != null) onRewarded(reward);
            if (_onRewardedGlobal != null) _onRewardedGlobal!(adItem, reward);
            break;
          case RewardAdEvent.completed:
          case RewardAdEvent.started:
            break;
          case RewardAdEvent.closed:
          case RewardAdEvent.leftApp:
            _loadedFlags.remove(adItem.id);
            try {
              (_ads[adItem.id] as RewardAd?)?.destroy();
            } catch (_) {}
            _ads.remove(adItem.id);
            // Preload next after close for higher fill rate.
            Future.delayed(const Duration(milliseconds: 600), () {
              if (!_ads.containsKey(adItem.id)) {
                _loadRewardAd(adItem, null, null, null, onRewarded, 0);
              }
            });
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
    _loadedFlags[adItem.id] = false;
    return ad;
  }
}
