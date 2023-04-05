import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_lite/connectivity_lite.dart';
import 'package:connectivity_lite/connectivity_lite_platform_interface.dart';
import 'package:connectivity_lite/connectivity_lite_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockConnectivityLitePlatform
    with MockPlatformInterfaceMixin
    implements ConnectivityLitePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ConnectivityLitePlatform initialPlatform = ConnectivityLitePlatform.instance;

  test('$MethodChannelConnectivityLite is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelConnectivityLite>());
  });

  test('getPlatformVersion', () async {
    ConnectivityLite connectivityLitePlugin = ConnectivityLite();
    MockConnectivityLitePlatform fakePlatform = MockConnectivityLitePlatform();
    ConnectivityLitePlatform.instance = fakePlatform;

    expect(await connectivityLitePlugin.getPlatformVersion(), '42');
  });
}
