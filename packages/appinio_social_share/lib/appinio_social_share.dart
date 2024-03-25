import 'package:appinio_social_share/appinio_social_share_platform_interface.dart';
import 'package:appinio_social_share/platforms/android.dart';
import 'package:appinio_social_share/platforms/ios.dart';

class AppinioSocialShare {
  Android android = Android();
  IOS iOS = IOS();

  Future<Map<String, bool>> getInstalledApps() async {
    return AppinioSocialSharePlatform.instance.getInstalledApps();
  }
}
