import '../models/advertisement_provider.dart';
import '../models/advertisement_type.dart';

import 'advertisement_item.dart';

enum AdvertisementViewType {
  widget,
  handle,
  openApp,
  none,
}

class AdvertisementView {
  bool active;
  AdvertisementItem data;

  AdvertisementView({
    this.active = false,
    required this.data,
  });

  AdvertisementViewType get type {
    switch (data.type) {
      case AdvertisementType.banner:
        if (data.provider == AdvertisementProvider.huawei) return AdvertisementViewType.handle;
        return AdvertisementViewType.widget;
      case AdvertisementType.native:
      case AdvertisementType.fluid:
      case AdvertisementType.roll:
        return AdvertisementViewType.widget;
      case AdvertisementType.interstitial:
      case AdvertisementType.reward:
      case AdvertisementType.splash:
        return AdvertisementViewType.handle;
      case AdvertisementType.openApp:
        return AdvertisementViewType.openApp;
      default:
        return AdvertisementViewType.none;
    }
  }
}
