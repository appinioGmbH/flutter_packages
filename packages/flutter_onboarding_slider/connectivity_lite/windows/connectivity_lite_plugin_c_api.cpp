#include "include/connectivity_lite/connectivity_lite_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "connectivity_lite_plugin.h"

void ConnectivityLitePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  connectivity_lite::ConnectivityLitePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
