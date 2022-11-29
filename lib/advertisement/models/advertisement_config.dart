import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../models/advertisement_provider.dart';
import 'advertisement_item.dart';

class AdvertisementConfig {
  final List<AdvertisementItem> ads;
  final bool enable;
  final String adMobAppIdAndroid;
  final String adMobAppIdIos;

  const AdvertisementConfig({
    this.ads = const <AdvertisementItem>[],
    this.enable = false,
    this.adMobAppIdAndroid = '',
    this.adMobAppIdIos = '',
  });

  AdvertisementConfig copyWith({
    List<AdvertisementItem>? ads,
    String? facebookTestingId,
    List<String>? googleTestingId,
    bool? enable,
    String? adMobAppIdAndroid,
    String? adMobAppIdIos,
    AdvertisementProvider? adProvider,
  }) {
    return AdvertisementConfig(
      ads: ads ?? this.ads,
      enable: enable ?? this.enable,
      adMobAppIdAndroid: adMobAppIdAndroid ?? this.adMobAppIdAndroid,
      adMobAppIdIos: adMobAppIdIos ?? this.adMobAppIdIos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ads': ads.map((x) => x.toMap()).toList(),
      'enable': enable,
      'adMobAppIdAndroid': adMobAppIdAndroid,
      'adMobAppIdIos': adMobAppIdIos,
    };
  }

  factory AdvertisementConfig.fromMap(Map<String, dynamic> map) {
    return AdvertisementConfig(
      ads: List<AdvertisementItem>.from(map['ads']?.map((x) => AdvertisementItem.fromMap(x))),
      enable: map['enable'] ?? false,
      adMobAppIdAndroid: map['adMobAppIdAndroid'] ?? '',
      adMobAppIdIos: map['adMobAppIdIos'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AdvertisementConfig.fromJson(String source) => AdvertisementConfig.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AdvertisementConfig(ads: $ads, enable: $enable, adMobAppIdAndroid: $adMobAppIdAndroid, adMobAppIdIos: $adMobAppIdIos)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AdvertisementConfig &&
        listEquals(other.ads, ads) &&
        other.enable == enable &&
        other.adMobAppIdAndroid == adMobAppIdAndroid &&
        other.adMobAppIdIos == adMobAppIdIos;
  }

  @override
  int get hashCode {
    return ads.hashCode ^ enable.hashCode ^ adMobAppIdAndroid.hashCode ^ adMobAppIdIos.hashCode;
  }
}
