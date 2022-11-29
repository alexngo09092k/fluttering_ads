import 'package:flutter/foundation.dart';

enum AdvertisementProvider { google, huawei, custom }

extension AdvertisementProviderExtension on AdvertisementProvider {
  String get content => describeEnum(this);
}
