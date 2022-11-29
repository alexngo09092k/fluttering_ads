//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <fluttering_ads/fluttering_ads_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) fluttering_ads_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutteringAdsPlugin");
  fluttering_ads_plugin_register_with_registrar(fluttering_ads_registrar);
}
