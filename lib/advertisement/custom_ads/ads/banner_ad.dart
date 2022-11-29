part of '../custom_advertisement.dart';

extension BannerAdEx on CustomAdvertisement {
  CustomBannerAd _loadBannerAd(
    AdvertisementItem adItem) {
    return CustomBannerAd();
  }
}

class CustomBannerAd extends CustomAd {}
