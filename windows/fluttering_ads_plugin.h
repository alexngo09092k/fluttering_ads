#ifndef FLUTTER_PLUGIN_FLUTTERING_ADS_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTERING_ADS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace fluttering_ads {

class FlutteringAdsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutteringAdsPlugin();

  virtual ~FlutteringAdsPlugin();

  // Disallow copy and assign.
  FlutteringAdsPlugin(const FlutteringAdsPlugin&) = delete;
  FlutteringAdsPlugin& operator=(const FlutteringAdsPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace fluttering_ads

#endif  // FLUTTER_PLUGIN_FLUTTERING_ADS_PLUGIN_H_
