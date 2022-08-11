import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_disable_screenshot/screenshot.dart';
import 'package:flutter_disable_screenshot/screenshot_platform_interface.dart';
import 'package:flutter_disable_screenshot/screenshot_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockScreenshotPlatform
    with MockPlatformInterfaceMixin
    implements ScreenshotPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ScreenshotPlatform initialPlatform = ScreenshotPlatform.instance;

  test('$MethodChannelScreenshot is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelScreenshot>());
  });

  test('getPlatformVersion', () async {
    Screenshot screenshotPlugin = Screenshot();
    MockScreenshotPlatform fakePlatform = MockScreenshotPlatform();
    ScreenshotPlatform.instance = fakePlatform;

    expect(await screenshotPlugin.getPlatformVersion(), '42');
  });
}
