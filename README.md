# fluttering_ads

**Unified ads module for the [Fluttering](https://pub.dev/packages/fluttering) toolkit.**

Supports **Google AdMob** and **Huawei Ads** with a single API for banner, interstitial, rewarded, splash, native, and app-open ads.

---

## Features

- Single entry point: `AwesomeAdvertisement`
- Providers: Google (`google_mobile_ads`) + Huawei (`huawei_ads`)
- Ad types: banner, interstitial, rewarded, splash, native, app-open
- Config-driven (`AdvertisementConfig` + list of `AdvertisementItem`)
- Integrates with Fluttering lifecycle (`ProviderDelegate`, splash hooks)
- Widget helper: `AdBuilder` / `widgetAd`

---

## Getting started

```yaml
dependencies:
  fluttering: ^3.0.0
  fluttering_ads: ^3.0.5
```

### Platform setup

Follow the official setup guides for:

- [Google Mobile Ads](https://developers.google.com/admob/flutter/quick-start)
- [Huawei Ads Kit](https://developer.huawei.com/consumer/en/doc/development/HMSCore-Guides/publisher-service-introduction-0000001070671805)

---

## Usage

```dart
import 'package:fluttering_ads/fluttering_ads.dart';

// 1. Configure
final config = AdvertisementConfig(
  enable: true,
  ads: [
    AdvertisementItem(
      id: 'ca-app-pub-xxx/banner',
      type: AdvertisementType.banner,
      provider: AdvertisementProvider.google,
    ),
    // ... more items (interstitial, rewarded, splash, native, ...)
  ],
);

// 2. Initialize (usually after AwesomeApp starts)
await AwesomeAdvertisement.instance.initial(config);

// 3. Show / get widget
final banner = AwesomeAdvertisement.instance.widgetAd(
  ad: config.ads.firstWhere((a) => a.type == AdvertisementType.banner),
);

// Or trigger interstitial / rewarded via handleAd(...)
AwesomeAdvertisement.instance.handleAd(ad: interstitialItem);
```

Register the provider with Fluttering if you want lifecycle integration:

```dart
AwesomeApp(
  app: MyApp(),
  providers: [
    ThemeProvider(),
    // AwesomeAdvertisement is a singleton Provider – register if needed
  ],
).run();
```

---

## Additional information

- Depends on the core **fluttering** package.
- Author: Brennan Ngo / ThemePlace
- License: MIT
