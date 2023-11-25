
import 'app_auth_check_platform_interface.dart';

class AppAuthCheck {
  Future<bool?> checkAppAuth() {
    return AppAuthCheckPlatform.instance.checkAppAuth();
  }
}
