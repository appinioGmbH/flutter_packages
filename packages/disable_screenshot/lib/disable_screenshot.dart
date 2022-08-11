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
}
