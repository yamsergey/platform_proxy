#include "include/platform_proxy/platform_proxy_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "platform_proxy_plugin.h"

void PlatformProxyPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  platform_proxy::PlatformProxyPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
