import 'appinio_social_share_platform_interface.dart';

class AppinioSocialShare {
  Future<Map> getInstalledApps() async {
    return AppinioSocialSharePlatform.instance.getInstalledApps();
  }

  Future<String> shareToWhatsapp(String message, {String? filePath}) {
    return AppinioSocialSharePlatform.instance
        .shareToWhatsapp(message, filePath: filePath);
  }

  Future<String> shareToTelegram(String message, {String? filePath}) {
    return AppinioSocialSharePlatform.instance
        .shareToTelegram(message, filePath: filePath);
  }

  Future<String> shareToTwitter(String message, {String? filePath}) {
    return AppinioSocialSharePlatform.instance
        .shareToTwitter(message, filePath: filePath);
  }

  Future<String> shareToInstagram(String message) {
    return AppinioSocialSharePlatform.instance.shareToInstagram(message);
  }

  Future<String> shareToMessenger(String message) {
    return AppinioSocialSharePlatform.instance.shareToMessenger(message);
  }

  Future<String> copyToClipBoard(String message) {
    return AppinioSocialSharePlatform.instance.copyToClipBoard(message);
  }

  Future<String> shareToFacebook(String hashtag, String filePath) {
    return AppinioSocialSharePlatform.instance
        .shareToFacebook(hashtag, filePath);
  }

  Future<String> shareToInstagramStory({String? stickerImage,
      String? backgroundImage,
      String? backgroundTopColor,
      String? backgroundBottomColor,
      String? attributionURL}) {
    return AppinioSocialSharePlatform.instance.shareToInstagramStory(
        stickerImage:stickerImage,
        backgroundImage: backgroundImage,
        backgroundTopColor: backgroundTopColor,
        backgroundBottomColor: backgroundBottomColor,
        attributionURL: attributionURL);
  }

  Future<String> shareToFacebookStory(String appId,
      {String? stickerImage,
      String? backgroundImage,
      String? backgroundTopColor,
      String? backgroundBottomColor,
      String? attributionURL}) {
    return AppinioSocialSharePlatform.instance.shareToFacebookStory(
        appId,
        stickerImage:stickerImage,
        backgroundImage: backgroundImage,
        backgroundTopColor: backgroundTopColor,
        backgroundBottomColor: backgroundBottomColor,
        attributionURL: attributionURL);
  }

  Future<String> shareToTiktok(String filePath) {
    return AppinioSocialSharePlatform.instance.shareToTiktok(filePath);
  }

  Future<String> shareToSystem(String title, String message,
      {String? filePath}) {
    return AppinioSocialSharePlatform.instance
        .shareToSystem(title, message, filePath: filePath);
  }

  Future<String> shareToSMS(String message, {String? filePath}) {
    return AppinioSocialSharePlatform.instance
        .shareToSMS(message, filePath: filePath);
  }
}
