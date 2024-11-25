import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_auth_check_platform_interface.dart';

/// An implementation of [AppAuthCheckPlatform] that uses method channels.
class MethodChannelAppAuthCheck extends AppAuthCheckPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('app_auth_check');

  @override
  Future<bool?> checkAppAuth() async {
    final bool? result = await methodChannel.invokeMethod<bool>('app_auth_check');
    return result;
  }
}
