import 'package:flutter/cupertino.dart';

import 'disable_screenshot_platform_interface.dart';

class DisableScreenshot {
  Future<String?> getPlatformVersion() {
    return DisableScreenshotPlatform.instance.getPlatformVersion();
  }

  Stream<void> onScreenShots() {
    return DisableScreenshotPlatform.instance.onScreenShots();
  }

  Future<void> disableScreenshots(bool disable) {
    return DisableScreenshotPlatform.instance.disableScreenshots(disable);
  }

  Future<String?> captureScreenShot({
    required GlobalKey screenshotWidgetKey,
    String name = 'screenshot',
  }) async {
    return DisableScreenshotPlatform.instance.captureScreenShot(
        screenshotWidgetKey: screenshotWidgetKey, name: name);
  }

  Future<String?> captureScreenShotFromWidget(Widget widget,
      {Duration delay = const Duration(milliseconds: 50),
      double? pixelRatio,
      BuildContext? context,
      String? filename}) async {
    return DisableScreenshotPlatform.instance.captureScreenShotFromWidget(
        widget,
        delay: delay,
        pixelRatio: pixelRatio,
        context: context,
        filename: filename);
  }
}
