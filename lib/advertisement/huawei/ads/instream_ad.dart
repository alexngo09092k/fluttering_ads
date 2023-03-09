part of '../huawei_advertisement.dart';

extension InstreamAdEx on HuaweiAdvertisement {
  Future<InstreamAdView?> _loadInstreamAdView(
    AdvertisementItem adItem, [
    Function(InstreamAdView)? onAd,
    Function(InstreamAdView?)? onLoadedAd,
    Function(int? error)? onAdFailedToLoad,
  ]) async {
    _instreamAdViewController ??= InstreamAdViewController(onInstreamAdViewCreated: (_) async {
      Debug.log('loadInstreamAdView created');
      if(_instreamAdViewController != null) {
        await _instreamAdViewController!.mute();
        _instreamAdViewController!.play();
      }
    }, onClick: () {
      Debug.log('loadInstreamAdView clicked');
    }, onSegmentMediaChange: (instreamAd) {
      Debug.log('loadInstreamAdView $instreamAd');
    }, onMediaStart: (playTime) {
      Debug.log('loadInstreamAdView $playTime');
    }, onMediaProgress: (per, playTime) {
      Debug.log('loadInstreamAdView $per $playTime');
    }, onMediaStop: (_) {
      Debug.log('loadInstreamAdView stopped');
    });

    await InstreamAdLoader(
      adId: adItem.id,
      totalDuration: const Duration(minutes: 1),
      maxCount: 8,
      onAdFailed: (int? errorCode) {
        Debug.log('failed load InstreamAdView errorCode $errorCode');
        if (onAdFailedToLoad != null) onAdFailedToLoad(errorCode);
      },
      onAdLoaded: (instreamAds) async {
        Debug.log('loaded InstreamAdView');
        _ads[adItem.id] = InstreamAdView(
          instreamAds: instreamAds,
          controller: _instreamAdViewController,
        );
        if (onLoadedAd != null && _ads[adItem.id] != null) onLoadedAd(_ads[adItem.id]);
      },
    ).loadAd(adParam: AdParam());
    await Future.delayed(const Duration(seconds: 2));
    if (_ads[adItem.id] != null) {
      if (onAd != null) {
        onAd(_ads[adItem.id]!);
      }
    }else if(onAdFailedToLoad != null) {
      onAdFailedToLoad(null);
    }
    return _ads[adItem.id];
  }
}
