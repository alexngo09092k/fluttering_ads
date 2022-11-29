import 'package:flutter/material.dart';

import '../base_advertisement.dart';
import '../models/advertisement_item.dart';
import '../models/advertisement_provider.dart';
import '../models/advertisement_type.dart';

part 'ads/banner_ad.dart';
part 'ads/custom_ad.dart';
part 'ads/interstitial_ad.dart';
part 'ads/open_app_ad.dart';


class CustomAdvertisement extends AdvertisementBase {
  @override
  AdvertisementProvider get adsProvider => AdvertisementProvider.custom;

  @override
  Widget? createAdWidget({required AdvertisementItem adItem, Function(dynamic)? onLoadedAd, Function(dynamic error)? onAdFailedToLoad}) {
    return null;

    // switch (adItem.type) {
    //   case AdvertisementType.banner:
    //     var bannerAd = _loadBannerAd(adItem, null, onLoadedAd, onAdFailedToLoad);
    //     return Container(
    //       alignment: Alignment.center,
    //       width: adItem.width ?? bannerAd.size.width.toDouble(),
    //       height: adItem.height ?? bannerAd.size.height.toDouble(),
    //       child: AdWidget(ad: bannerAd),
    //     );
    //   default:
    //     return const SizedBox();
    // }
  }

  @override
  void hideAd(AdvertisementItem adItem) {}

  @override
  void hideLoadedAd({required loadedAd, required AdvertisementType type}) {}

  @override
  bool isSupported() {
    throw UnimplementedError();
  }

  @override
  void loadAd(
      {required AdvertisementItem adItem, Function(dynamic p1)? onAd, Function(dynamic ad)? onLoadedAd, Function(dynamic error)? onAdFailedToLoad}) {}

  @override
  void showAd({required AdvertisementItem adItem}) {}

  @override
  void showLoadedAd({required loadedAd, required AdvertisementType type}) {}
}
