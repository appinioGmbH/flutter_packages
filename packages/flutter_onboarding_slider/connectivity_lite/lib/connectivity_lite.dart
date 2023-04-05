
import 'connectivity_lite_platform_interface.dart';

class ConnectivityLite {
  Future<String?> getPlatformVersion() {
    return ConnectivityLitePlatform.instance.getPlatformVersion();
  }
}
