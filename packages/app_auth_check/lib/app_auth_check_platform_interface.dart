import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_auth_check_method_channel.dart';

abstract class AppAuthCheckPlatform extends PlatformInterface {
  /// Constructs a AppAuthCheckPlatform.
  AppAuthCheckPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppAuthCheckPlatform _instance = MethodChannelAppAuthCheck();

  /// The default instance of [AppAuthCheckPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppAuthCheck].
  static AppAuthCheckPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppAuthCheckPlatform] when
  /// they register themselves.
  static set instance(AppAuthCheckPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> checkAppAuth() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
