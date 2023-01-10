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
  final Duration waitingTimeToDisplay;
  final double? width;
  final double? height;

  AdvertisementItem({
    this.type = AdvertisementType.banner,
    this.provider = AdvertisementProvider.google,
    this.androidId = '',
    this.iosId = '',
    this.showOnScreens = const <String>[],
    this.hideOnScreens = const <String>[],
    this.waitingTimeToDisplay = Duration.zero,
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
    Duration? waitingTimeToDisplay,
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
      'waitingTimeToDisplay': waitingTimeToDisplay.inMilliseconds,
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
      showOnScreens: List<String>.from(map['showOnScreens'] ?? []),
      hideOnScreens: List<String>.from(map['hideOnScreens'] ?? []),
      waitingTimeToDisplay: Duration(milliseconds: int.parse(map['waitingTimeToDisplay'] ?? '0')),
      width: map['width'] is String ? double.tryParse(map['width']) : null,
      height: map['width'] is String ? double.tryParse(map['height']) : null,
    );
  }

  AdvertisementViewType get viewType {
    switch (type) {
      case AdvertisementType.banner:
        if (provider == AdvertisementProvider.huawei) return AdvertisementViewType.handle;
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
