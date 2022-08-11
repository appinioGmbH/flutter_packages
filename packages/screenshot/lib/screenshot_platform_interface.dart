import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'screenshot_method_channel.dart';

abstract class ScreenshotPlatform extends PlatformInterface {
  /// Constructs a ScreenshotPlatform.
  ScreenshotPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScreenshotPlatform _instance = MethodChannelScreenshot();

  /// The default instance of [ScreenshotPlatform] to use.
  ///
  /// Defaults to [MethodChannelScreenshot].
  static ScreenshotPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ScreenshotPlatform] when
  /// they register themselves.
  static set instance(ScreenshotPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
