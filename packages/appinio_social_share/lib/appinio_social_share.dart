import 'dart:io';

import 'appinio_social_share_platform_interface.dart';

class AppinioSocialShare {
  Future<Map> getInstalledApps() async {
    return AppinioSocialSharePlatform.instance.getInstalledApps();
  }

  Future<String> shareToWhatsapp(String message, {List<String>? filePaths}) {
    return AppinioSocialSharePlatform.instance
        .shareToWhatsapp(message, filePaths: filePaths);
  }

  Future<String> shareToTelegram(String message, {List<String>? filePaths}) {
    return AppinioSocialSharePlatform.instance
        .shareToTelegram(message, filePaths: filePaths);
  }

  Future<String> shareToTwitter(String message, {List<String>? filePaths}) {
    return AppinioSocialSharePlatform.instance
        .shareToTwitter(message, filePaths: filePaths);
  }

  Future<String> shareToInstagramDirect(String message) {
    return AppinioSocialSharePlatform.instance.shareToInstagramDirect(message);
  }

  Future<String> shareToInstagramFeed(List<String> imagePaths) {
    return AppinioSocialSharePlatform.instance.shareToInstagramFeed(imagePaths);
  }

  Future<String> shareToInstagramReels(List<String> videoPaths) {
    return AppinioSocialSharePlatform.instance.shareToInstagramFeed(videoPaths);
  }

  Future<String> shareToMessenger(String message) {
    return AppinioSocialSharePlatform.instance.shareToMessenger(message);
  }

  Future<String> copyToClipBoard(String message) {
    return AppinioSocialSharePlatform.instance.copyToClipBoard(message);
  }

  Future<String> shareToFacebook(String hashtag, List<String> filePaths) {
    return AppinioSocialSharePlatform.instance
        .shareToFacebook(hashtag, filePaths);
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
  Future<String> shareToTiktokStatus(List<String> filePaths) {
    if (Platform.isIOS) return Future.value("Not implemented!");
    return AppinioSocialSharePlatform.instance.shareToTiktokStatus(filePaths);
  }

  Future<String> shareToTiktokPost(
      String videoFile, String redirectUrl, TiktokFileType tiktokFileType) {
    if (Platform.isAndroid) return shareToTiktokStatus([videoFile]);
    return AppinioSocialSharePlatform.instance
        .shareToTiktokPost(videoFile, redirectUrl, tiktokFileType);
  }

  Future<String> shareToSystem(String title, String message,
      {List<String>? filePaths}) {
    return AppinioSocialSharePlatform.instance
        .shareToSystem(title, message, filePaths: filePaths);
  }

  Future<String> shareToSMS(String message, {List<String>? filePaths}) {
    return AppinioSocialSharePlatform.instance
        .shareToSMS(message, filePaths: filePaths);
  }
}
