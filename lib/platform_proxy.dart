import 'dart:async';

import 'package:flutter/services.dart';

class PlatformProxy {
  static const MethodChannel _channel = MethodChannel('platform_proxy');

  Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod<dynamic>('getPlatformVersion') as String;
    return version;
  }

  Future<String> getPlatformProxy() async {
    final String version = await _channel.invokeMethod<dynamic>(
        'getPlatformProxy', <String, String>{'url': 'http://hello'}) as String;
    return version;
  }
}
