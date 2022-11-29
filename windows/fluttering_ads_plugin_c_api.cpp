#include "include/fluttering_ads/fluttering_ads_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "fluttering_ads_plugin.h"

void FlutteringAdsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  fluttering_ads::FlutteringAdsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
