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

  /// One of imagesPath or videosPath must not be empty
  /// iOS restrictions:
  /// Up to 20 combined images and videos.
  /// [videosPath]: 1 video at most
  /// [imagesPath]: 20 images at most or 19 in case you set videoPath as well
  /// Official docs for ShareMediaContent on iOS: https://developers.facebook.com/docs/sharing/ios
  ///
  /// Android restrictions:
  /// Up to 6 combined images and videos.
  /// [videosPath]: 6 videos at most, depending on how much images you set
  /// [imagesPath]: 6 images at most, depending on how much videos you set
  /// Official docs for ShareMediaContent on iOS: https://developers.facebook.com/docs/sharing/android
  Future<String> shareToFacebook(
      String hashtag,
      @Deprecated('This param will no longer be used in upcoming versions, instead use imagesPath')
          String? filePath,
      {List<String>? imagesPath,
      List<String>? videosPath}) {
    return AppinioSocialSharePlatform.instance.shareToFacebook(
        hashtag, filePath,
        imagesPath: imagesPath, videosPath: videosPath);
  }

  Future<String> shareToInstagramStory(
      {String? stickerImage,
      String? backgroundImage,
      String? backgroundVideo,
      String? backgroundTopColor,
      String? backgroundBottomColor,
      String? attributionURL}) {
    return AppinioSocialSharePlatform.instance.shareToInstagramStory(
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

  /// Available only for iOS, for Android will redirect to TikTokStatus
  ///
  /// Only one of imagesPath or videosPath must not be empty
  /// iOS and Android restrictions:
  /// Up to 12 combined images and videos.
  /// [videosPath]: 12 videos at most, depending on how much images you set
  /// [imagesPath]: 12 images at most, depending on how much videos you set
  /// Official docs iOS: https://developers.tiktok.com/doc/video-kit-ios-video-kit-with-swift/
  /// Official docs Android: https://developers.tiktok.com/doc/video-kit-android-video-kit-with-android/
  Future<String> shareToTiktokPost(
      @Deprecated('This param will no longer be used in upcoming versions, instead use videosPath')
      String? videoFile, {
        List<String>? imagesPath,
        List<String>? videosPath,
      }) {
    return AppinioSocialSharePlatform.instance.shareToTiktokPost(videoFile, imagesPath: imagesPath, videosPath: videosPath);
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
