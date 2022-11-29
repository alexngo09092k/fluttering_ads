part of '../custom_advertisement.dart';

extension InterstitialAdEx on CustomAdvertisement {
  void _loadInterstitialAd(
    AdvertisementItem adItem, [
    Function(CustomInterstitialAd)? onAd,
    Function(CustomInterstitialAd)? onLoadedAd,
    Function(CustomAdError error)? onAdFailedToLoad,
  ]) {}
}

class CustomInterstitialAd extends CustomAd {}
