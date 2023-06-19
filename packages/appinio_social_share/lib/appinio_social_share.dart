import 'dart:io';

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

  Future<String> shareToInstagramDirect(String message) {
    return AppinioSocialSharePlatform.instance.shareToInstagramDirect(message);
  }

  Future<String> shareToInstagramFeed(String imagePath) {
    return AppinioSocialSharePlatform.instance.shareToInstagramFeed(imagePath);
  }

  Future<String> shareToInstagramReels(String videoPath) {
    return AppinioSocialSharePlatform.instance.shareToInstagramFeed(videoPath);
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

  Future<String> shareToInstagramStory(String appId,
      {String? stickerImage,
      String? backgroundImage,
      String? backgroundVideo,
      String? backgroundTopColor,
      String? backgroundBottomColor,
      String? attributionURL}) {
    return AppinioSocialSharePlatform.instance.shareToInstagramStory(appId,
        stickerImage: stickerImage,
        backgroundImage: backgroundImage,
        backgroundVideo: backgroundVideo,
        backgroundTopColor: backgroundTopColor,
        backgroundBottomColor: backgroundBottomColor,
        attributionURL: attributionURL);
  }

  Future<String> shareToFacebookStory(String appId,
      {String? stickerImage,
      String? backgroundImage,
      String? backgroundVideo,
      String? backgroundTopColor,
      String? backgroundBottomColor,
      String? attributionURL}) {
    return AppinioSocialSharePlatform.instance.shareToFacebookStory(appId,
        stickerImage: stickerImage,
        backgroundImage: backgroundImage,
        backgroundVideo: backgroundVideo,
        backgroundTopColor: backgroundTopColor,
        backgroundBottomColor: backgroundBottomColor,
        attributionURL: attributionURL);
  }

  ///works only for android
  Future<String> shareToTiktokStatus(String filePath) {
    return AppinioSocialSharePlatform.instance.shareToTiktokStatus(filePath);
  }

  Future<String> shareToTiktokPost(String videoFile) {
    if (Platform.isAndroid) return shareToTiktokStatus(videoFile);
    return AppinioSocialSharePlatform.instance.shareToTiktokPost(videoFile);
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
