import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screenshot_platform_interface.dart';

class MethodChannelScreenshot extends ScreenshotPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('screenshot');
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
  Stream<void> get onScreenShots {
    _onScreenShots ??= _eventChannel.receiveBroadcastStream();
    return _onScreenShots!;
  }

  Future<dynamic> disableScreenshots(bool disable) async {
    if (Platform.isAndroid) {
      return await _methodChannel
          .invokeMethod("disableScreenshots", {"disable": disable});
    } else {
      // print('仅Android平台支持禁用屏幕截图');
    }
  }
}
