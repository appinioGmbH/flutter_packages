import 'package:flutter_test/flutter_test.dart';
import 'package:app_auth_check/app_auth_check.dart';
import 'package:app_auth_check/app_auth_check_platform_interface.dart';
import 'package:app_auth_check/app_auth_check_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppAuthCheckPlatform
    with MockPlatformInterfaceMixin
    implements AppAuthCheckPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool?> checkAppAuth() {
    // TODO: implement checkAppAuth
    throw UnimplementedError();
  }
}

void main() {
  final AppAuthCheckPlatform initialPlatform = AppAuthCheckPlatform.instance;

  test('$MethodChannelAppAuthCheck is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppAuthCheck>());
  });

  test('getPlatformVersion', () async {
    AppAuthCheck appAuthCheckPlugin = AppAuthCheck();
    MockAppAuthCheckPlatform fakePlatform = MockAppAuthCheckPlatform();
    AppAuthCheckPlatform.instance = fakePlatform;

  });
}
