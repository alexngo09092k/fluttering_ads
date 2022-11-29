part of '../custom_advertisement.dart';

class CustomAd {
  dispose() {}

  show() {}
}

class CustomAdError extends Error {
  final String message;

  CustomAdError(this.message);
}

class CustomAdWidget extends StatelessWidget {
  const CustomAdWidget({super.key, required this.ad});

  final CustomAd ad;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
