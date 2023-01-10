import 'package:flutter/material.dart';
import 'package:fluttering/fluttering.dart';
import 'package:fluttering_ads/fluttering_ads.dart';

class AdBuilder extends StatefulWidget {
  const AdBuilder({super.key, this.ad, this.errorBuilder, this.width, this.height, this.borderRadius});
  final Widget Function(BuildContext)? errorBuilder;
  final AdvertisementItem? ad;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  @override
  State<AdBuilder> createState() => _AdBuilderState();
}

class _AdBuilderState extends ProviderState<AdBuilder, AwesomeAdvertisement> {
  Widget? adWidget;
  bool? canShow;

  @override
  void initState() {
    super.initState();
    adWidget = provider.widgetAd(
        ad: widget.ad,
        onLoadedAd: (_) {
          canShow = true;
          setState(() {});
        },
        onAdFailedToLoad: (_) {
          canShow = false;
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if ((widget.errorBuilder != null && canShow == false) || canShow == null) widget.errorBuilder!(context),
            if ((adWidget != null && canShow == true) || canShow == null) adWidget!,
          ],
        ),
      ),
    );
  }
}
