import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:disable_screenshot/disable_screenshot_method_channel.dart';

void main() {
  MethodChannelDisableScreenshot platform = MethodChannelDisableScreenshot();
  const MethodChannel channel = MethodChannel('disable_screenshot');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
