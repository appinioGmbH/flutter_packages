import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
<<<<<<< HEAD:packages/disable_screenshot/test/disable_screenshot_method_channel_test.dart
import 'package:disable_screenshot/disable_screenshot_method_channel.dart';
=======
import 'package:flutter_disable_screenshot/screenshot_method_channel.dart';
>>>>>>> df67589dc8c2cd32cd3da53479e3f9656be9a9d2:packages/flutter_disable_screenshot/test/screenshot_method_channel_test.dart

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
