import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_auth_check/app_auth_check_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAppAuthCheck platform = MethodChannelAppAuthCheck();
  const MethodChannel channel = MethodChannel('app_auth_check');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
  });
}
