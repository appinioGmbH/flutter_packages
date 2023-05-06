import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'appinio_social_share_method_channel.dart';

abstract class AppinioSocialSharePlatform extends PlatformInterface {
  /// Constructs a AppinioSocialSharePlatform.
  AppinioSocialSharePlatform() : super(token: _token);

  static final Object _token = Object();

  static AppinioSocialSharePlatform _instance =
      MethodChannelAppinioSocialShare();

  /// The default instance of [AppinioSocialSharePlatform] to use.
  ///
  /// Defaults to [MethodChannelAppinioSocialShare].
  static AppinioSocialSharePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppinioSocialSharePlatform] when
  /// they register themselves.
  static set instance(AppinioSocialSharePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map> getInstalledApps() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  ///filaPath only works for android
  Future<String> shareToWhatsapp(String message, {String? filePath}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToInstagramDirect(String message) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToInstagramFeed(String filePath) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToMessenger(String message) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  ///This function only works for android
  Future<String> shareToTiktokStatus(String filePath) {
    throw UnimplementedError('platformVersion() has not been implemented.');
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
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToTwitter(String message, {String? filePath}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  ///filepath only works for android
  Future<String> shareToTelegram(String message, {String? filePath}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
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
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToInstagramStory(
      {String? stickerImage,
      String? backgroundImage,
      String? backgroundVideo,
      String? backgroundTopColor,
      String? backgroundBottomColor,
      String? attributionURL}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToFacebookStory(String appId,
      {String? stickerImage,
      String? backgroundImage,
      String? backgroundVideo,
      String? backgroundTopColor,
      String? backgroundBottomColor,
      String? attributionURL}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> copyToClipBoard(String message) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToSystem(String title, String message,
      {String? filePath}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  ///filePath only works for android
  Future<String> shareToSMS(String message, {String? filePath}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
