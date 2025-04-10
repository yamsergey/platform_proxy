
import 'platform_proxy_platform_interface.dart';

class PlatformProxy {
  Future<String?> getPlatformVersion() {
    return PlatformProxyPlatform.instance.getPlatformVersion();
  }
}
