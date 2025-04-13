package io.yamsergey.flutter.platform_proxy

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.net.URI

class PlatformProxyPlugin: FlutterPlugin, MethodCallHandler {

  private lateinit var channel : MethodChannel

  private val proxyResolver = ProxyResolver()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "platform_proxy")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformProxy") {
      val url = call.argument<String>("url")

      if (url == null) {
        result.error("INVALID_ARGUMENT", "URL is null", null)
        return
      }

      val proxies = proxyResolver.resolve(url)
      val stringifier = ProxyStringifier(proxies)
      result.success(stringifier.stringify(URI.create(url)))
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
