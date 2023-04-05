import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'connectivity_lite_method_channel.dart';

abstract class ConnectivityLitePlatform extends PlatformInterface {
  /// Constructs a ConnectivityLitePlatform.
  ConnectivityLitePlatform() : super(token: _token);

  static final Object _token = Object();

  static ConnectivityLitePlatform _instance = MethodChannelConnectivityLite();

  /// The default instance of [ConnectivityLitePlatform] to use.
  ///
  /// Defaults to [MethodChannelConnectivityLite].
  static ConnectivityLitePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ConnectivityLitePlatform] when
  /// they register themselves.
  static set instance(ConnectivityLitePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
