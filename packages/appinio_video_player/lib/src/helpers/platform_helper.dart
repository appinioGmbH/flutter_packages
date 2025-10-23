import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Helper class for platform-specific checks and operations
class PlatformHelper {
  const PlatformHelper();

  /// Check if running on web platform
  bool get isWeb => kIsWeb;

  /// Check if running on Android platform
  bool isAndroid(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.android;

  /// Check if running on iOS platform
  bool isIOS(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.iOS;

  /// Check if platform supports playback speed changes
  bool supportsPlaybackSpeedChange(BuildContext context) => !isIOS(context);
}
