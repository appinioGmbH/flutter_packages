import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'disable_screenshot_method_channel.dart';

abstract class DisableScreenshotPlatform extends PlatformInterface {
  /// Constructs a DisableScreenshotPlatform.
  DisableScreenshotPlatform() : super(token: _token);

  static final Object _token = Object();

  static DisableScreenshotPlatform _instance = MethodChannelDisableScreenshot();

  /// The default instance of [DisableScreenshotPlatform] to use.
  ///
  /// Defaults to [MethodChannelDisableScreenshot].
  static DisableScreenshotPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DisableScreenshotPlatform] when
  /// they register themselves.
  static set instance(DisableScreenshotPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Stream<void> onScreenShots() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> disableScreenshots(bool disable) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> captureScreenShot({
    required GlobalKey screenshotWidgetKey,
    String name = 'screenshot',
  }) {
    throw UnimplementedError('captureScreenShot() has not been implemented.');
  }

  Future<String?> captureScreenShotFromWidget(Widget widget,
      {Duration delay = const Duration(milliseconds: 50),
      double? pixelRatio,
      BuildContext? context,
      String? filename}) {
    throw UnimplementedError(
        'captureScreenShotFromWidget() has not been implemented.');
  }
}
