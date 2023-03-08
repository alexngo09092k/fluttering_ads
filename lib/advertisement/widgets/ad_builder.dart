import 'package:flutter/material.dart';
import 'package:fluttering/fluttering.dart';
import 'package:fluttering_ads/fluttering_ads.dart';

class AdBuilder extends StatefulWidget {
  const AdBuilder({
    super.key,
    this.ad,
    this.errorBuilder,
    this.width,
    this.height,
    this.borderRadius,
    required this.successBuilder,
    this.awaitTime = const Duration(seconds: 2),
  });
  final Widget Function(BuildContext)? errorBuilder;
  final Widget Function(BuildContext, Widget) successBuilder;
  final AdvertisementItem? ad;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final Duration awaitTime;

  @override
  State<AdBuilder> createState() => _AdBuilderState();
}

class _AdBuilderState
    extends ProviderStateful<AdBuilder, AwesomeAdvertisement> {
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
      },
    );

    Future.delayed(widget.awaitTime, () {
      if (canShow == null) {
        canShow = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!provider.config.enable) return const SizedBox();
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: SizedBox(
        width: (widget.errorBuilder == null && canShow == false)? 0: widget.width,
        height: (widget.errorBuilder == null && canShow == false)? 0: widget.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            adWidget != null && (canShow == true || canShow == null)
                ? widget.successBuilder(context, adWidget!)
                : (widget.errorBuilder != null? widget.errorBuilder!(context): const SizedBox()),
          ],
        ),
      ),
    );
  }
}
