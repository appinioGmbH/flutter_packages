//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <connectivity_lite/connectivity_lite_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) connectivity_lite_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ConnectivityLitePlugin");
  connectivity_lite_plugin_register_with_registrar(connectivity_lite_registrar);
}
