import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fluttering/fluttering.dart';

import 'advertisement_type.dart';
import 'advertisement_provider.dart';

class AdvertisementItem {
  final AdvertisementType type;
  final AdvertisementProvider provider;
  final String androidId;
  final String iosId;
  final List<String> showOnScreens;
  final List<String> hideOnScreens;
  final int waitingTimeToDisplay;
  final double? width;
  final double? height;

  AdvertisementItem({
    this.type = AdvertisementType.banner,
    this.provider = AdvertisementProvider.google,
    this.androidId = '',
    this.iosId = '',
    this.showOnScreens = const <String>[],
    this.hideOnScreens = const <String>[],
    this.waitingTimeToDisplay = 1,
    this.width,
    this.height,
  });

  String get id => CurrentPlatform.instance.isAndroid ? androidId : iosId;

  AdvertisementItem copyWith({
    AdvertisementType? type,
    AdvertisementProvider? provider,
    String? androidId,
    String? iosId,
    List<String>? showOnScreens,
    List<String>? hideOnScreens,
    int? waitingTimeToDisplay,
    double? width,
    double? height,
  }) {
    return AdvertisementItem(
      type: type ?? this.type,
      provider: provider ?? this.provider,
      androidId: androidId ?? this.androidId,
      iosId: iosId ?? this.iosId,
      showOnScreens: showOnScreens ?? this.showOnScreens,
      hideOnScreens: hideOnScreens ?? this.hideOnScreens,
      waitingTimeToDisplay: waitingTimeToDisplay ?? this.waitingTimeToDisplay,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'provider': provider.name,
      'androidId': androidId,
      'iosId': iosId,
      'showOnScreens': showOnScreens,
      'hideOnScreens': hideOnScreens,
      'waitingTimeToDisplay': waitingTimeToDisplay,
      'width': width,
      'height': height,
    };
  }

  factory AdvertisementItem.fromMap(Map<String, dynamic> map) {
    return AdvertisementItem(
      type: AdvertisementType.values.firstWhere((element) => describeEnum(element) == map['type']),
      provider: AdvertisementProvider.values.firstWhere((element) => describeEnum(element) == map['provider']),
      androidId: map['androidId'] ?? '',
      iosId: map['iosId'] ?? '',
      showOnScreens: List<String>.unmodifiable(map['showOnScreens'] ?? <String>[]),
      hideOnScreens: List<String>.unmodifiable(map['hideOnScreens'] ?? <String>[]),
      waitingTimeToDisplay: (map['waitingTimeToDisplay'] ?? 0).toInt(),
      width: (map['width'] ?? 0.0) as double,
      height: (map['height'] ?? 0.0) as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdvertisementItem.fromJson(String source) => AdvertisementItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AdvertisementItem(type: $type, provider: $provider, androidId: $androidId, iosId: $iosId, showOnScreens: $showOnScreens, hideOnScreens: $hideOnScreens, waitingTimeToDisplay: $waitingTimeToDisplay, width: $width, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AdvertisementItem &&
        other.type == type &&
        other.provider == provider &&
        other.androidId == androidId &&
        other.iosId == iosId &&
        listEquals(other.showOnScreens, showOnScreens) &&
        listEquals(other.hideOnScreens, hideOnScreens) &&
        other.width == width &&
        other.height == height &&
        other.waitingTimeToDisplay == waitingTimeToDisplay;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        provider.hashCode ^
        androidId.hashCode ^
        iosId.hashCode ^
        showOnScreens.hashCode ^
        hideOnScreens.hashCode ^
        width.hashCode ^
        height.hashCode ^
        waitingTimeToDisplay.hashCode;
  }
}
