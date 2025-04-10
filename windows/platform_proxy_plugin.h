#ifndef FLUTTER_PLUGIN_PLATFORM_PROXY_PLUGIN_H_
#define FLUTTER_PLUGIN_PLATFORM_PROXY_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace platform_proxy {

class PlatformProxyPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  PlatformProxyPlugin();

  virtual ~PlatformProxyPlugin();

  // Disallow copy and assign.
  PlatformProxyPlugin(const PlatformProxyPlugin&) = delete;
  PlatformProxyPlugin& operator=(const PlatformProxyPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace platform_proxy

#endif  // FLUTTER_PLUGIN_PLATFORM_PROXY_PLUGIN_H_
