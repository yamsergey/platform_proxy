import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'platform_proxy_method_channel.dart';

abstract class PlatformProxyPlatform extends PlatformInterface {
  /// Constructs a PlatformProxyPlatform.
  PlatformProxyPlatform() : super(token: _token);

  static final Object _token = Object();

  static PlatformProxyPlatform _instance = MethodChannelPlatformProxy();

  /// The default instance of [PlatformProxyPlatform] to use.
  ///
  /// Defaults to [MethodChannelPlatformProxy].
  static PlatformProxyPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PlatformProxyPlatform] when
  /// they register themselves.
  static set instance(PlatformProxyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
