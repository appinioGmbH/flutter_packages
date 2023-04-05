import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'connectivity_lite_platform_interface.dart';

/// An implementation of [ConnectivityLitePlatform] that uses method channels.
class MethodChannelConnectivityLite extends ConnectivityLitePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('connectivity_lite');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
