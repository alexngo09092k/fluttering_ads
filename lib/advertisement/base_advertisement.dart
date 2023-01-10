import 'package:flutter/material.dart';
import 'models/advertisement_type.dart';
import 'models/advertisement_provider.dart';
import 'models/advertisement_item.dart';

abstract class BaseAdvertisement {
  AdvertisementProvider get provider;

  bool get isSupported;

  void showAd({required AdvertisementItem adItem, Function(dynamic error)? onAdFailedToLoad});

  void showLoadedAd({required dynamic loadedAd, required AdvertisementType type});

  void hideAd(AdvertisementItem adItem);

  void hideLoadedAd({required dynamic loadedAd, required AdvertisementType type});

  void loadAd({
    required AdvertisementItem adItem,
    Function(dynamic)? onAd,
    Function(dynamic ad)? onLoadedAd,
    Function(dynamic error)? onAdFailedToLoad,
  });

  Widget createAdWidget({
    required AdvertisementItem adItem,
    Function(dynamic)? onLoadedAd,
    Function(dynamic error)? onAdFailedToLoad,
  });
}
