// import 'package:flutter_test/flutter_test.dart';
// import 'package:disable_screenshot/disable_screenshot.dart';
// import 'package:disable_screenshot/disable_screenshot_platform_interface.dart';
// import 'package:disable_screenshot/disable_screenshot_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockDisableScreenshotPlatform 
//     with MockPlatformInterfaceMixin
//     implements DisableScreenshotPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final DisableScreenshotPlatform initialPlatform = DisableScreenshotPlatform.instance;

//   test('$MethodChannelDisableScreenshot is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelDisableScreenshot>());
//   });

//   test('getPlatformVersion', () async {
//     DisableScreenshot disableScreenshotPlugin = DisableScreenshot();
//     MockDisableScreenshotPlatform fakePlatform = MockDisableScreenshotPlatform();
//     DisableScreenshotPlatform.instance = fakePlatform;
  
//     expect(await disableScreenshotPlugin.getPlatformVersion(), '42');
//   });
// }
