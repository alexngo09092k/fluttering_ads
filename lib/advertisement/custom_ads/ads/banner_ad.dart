part of '../custom_advertisement.dart';

extension BannerAdEx on CustomAdvertisement {
  CustomBannerAd _loadBannerAd(
    AdvertisementItem adItem, [
    Function(CustomBannerAd)? onAd,
    Function(CustomBannerAd)? onLoadedAd,
    Function(CustomAdError error)? onAdFailedToLoad,
  ]) {
    return CustomBannerAd();
  }
}

class CustomBannerAd extends CustomAd {}
