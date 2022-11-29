part of '../huawei_advertisement.dart';

extension NativeAdEx on HuaweiAdvertisement {
  NativeAd _loadNativeAd(
    AdvertisementItem adItem, [
    Function(NativeAd)? onAd,
    Function(NativeAd?)? onLoadedAd,
    Function(int? error)? onAdFailedToLoad,
    NativeAdType type = NativeAdType.banner,
  ]) {
    _ads[adItem.id] = NativeAd(
      adSlotId: adItem.id,
      styles: NativeStyles()
        ..setCallToAction(fontSize: 8)
        ..setFlag(fontSize: 10)
        ..setSource(fontSize: 11),
      type: type,
      controller: NativeAdController(
        adConfiguration: NativeAdConfiguration()..choicesPosition = NativeAdChoicesPosition.BOTTOM_LEFT,
        listener: (AdEvent event, {errorCode}) {
          Debug.log('loadNativeAd $event');
          switch (event) {
            //  case AdEvent.closed:
            //  case AdEvent.leave:
            case AdEvent.failed:
              if (onAdFailedToLoad != null) onAdFailedToLoad(errorCode);
              break;
            //  case AdEvent.clicked:
            //  case AdEvent.impression:
            //  case AdEvent.disliked:
            case AdEvent.loaded:
            case AdEvent.opened:
              if (onLoadedAd != null) onLoadedAd(_ads[adItem.id]);
              break;
            default:
          }
        },
      ),
    );
    if (onAd != null) {
      onAd(_ads[adItem.id]);
    }
    return _ads[adItem.id];
  }
}
