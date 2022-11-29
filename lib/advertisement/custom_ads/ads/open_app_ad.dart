part of '../custom_advertisement.dart';

extension OpenAppAdEx on CustomAdvertisement {
  _loadOpenAppAd(
    AdvertisementItem adItem, [
    Function(CustomOpenAppAd)? onAd,
    Function(CustomOpenAppAd)? onLoadedAd,
    Function(CustomAdError error)? onAdFailedToLoad,
  ]) {}
}

class CustomOpenAppAd extends CustomAd {}
