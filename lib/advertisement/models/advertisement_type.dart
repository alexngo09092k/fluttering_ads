import 'package:flutter/foundation.dart';

enum AdvertisementType {
  openApp,
  fluid,
  banner,
  reward,
  native,
  interstitial,
  splash,
  roll,
}

extension AdvertisementTypeExtension on AdvertisementType {
  String get content => describeEnum(this);
}
