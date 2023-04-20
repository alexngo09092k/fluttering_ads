import 'package:flutter/material.dart';
import 'package:fluttering_ads/fluttering_ads.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AwesomeAdvertisement advertisement;
  @override
  void initState() {
    super.initState();
    advertisement = AwesomeAdvertisement();
    advertisement.initial(const AdvertisementConfig(ads: []));
    advertisement.handleAd();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(
          child: Text('This is example for fluttering ads'),
        ),
      ),
    );
  }
}
