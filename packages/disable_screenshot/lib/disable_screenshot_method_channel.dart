import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'disable_screenshot_platform_interface.dart';

/// An implementation of [DisableScreenshotPlatform] that uses method channels.
class MethodChannelDisableScreenshot extends DisableScreenshotPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('disable_screenshot');
  final MethodChannel _methodChannel =
      const MethodChannel("com.appinio.screenshot/disableScreenshots");
  final EventChannel _eventChannel =
      const EventChannel('com.appinio.screenshot/observer');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Stream<void>? _onScreenShots;
  @override
  Stream<void> onScreenShots() {
    _onScreenShots ??= _eventChannel.receiveBroadcastStream();
    return _onScreenShots!;
  }

  @override
  Future<void> disableScreenshots(bool disable) async {
    if (Platform.isAndroid) {
      return await _methodChannel.invokeMethod("disableScreenshots", disable);
    } else {
      // print('Disabling screenshots is only supported on Android');
    }
  }
}
