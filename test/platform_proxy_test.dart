import 'package:flutter_test/flutter_test.dart';
import 'package:platform_proxy/platform_proxy.dart';
import 'package:platform_proxy/platform_proxy_platform_interface.dart';
import 'package:platform_proxy/platform_proxy_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPlatformProxyPlatform
    with MockPlatformInterfaceMixin
    implements PlatformProxyPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PlatformProxyPlatform initialPlatform = PlatformProxyPlatform.instance;

  test('$MethodChannelPlatformProxy is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPlatformProxy>());
  });

  test('getPlatformVersion', () async {
    PlatformProxy platformProxyPlugin = PlatformProxy();
    MockPlatformProxyPlatform fakePlatform = MockPlatformProxyPlatform();
    PlatformProxyPlatform.instance = fakePlatform;

    expect(await platformProxyPlugin.getPlatformVersion(), '42');
  });
}
