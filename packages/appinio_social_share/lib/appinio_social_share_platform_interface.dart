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

  Future<Map<String, bool>> getInstalledApps() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  ///filaPath only works for android
  Future<String> shareToWhatsapp(String message, {List<String>? filePaths}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToInstagramDirect(String message) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToInstagramFeed(String message, String? filePath) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToInstagramFeedAndroid(List<String> filePaths) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToMessenger(String message) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  ///This function only works for android
  Future<String> shareToTiktokStatus(List<String> filePaths) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  ///This function only works for iOS
  Future<String> shareToTiktokPost(
      String filePath, String redirectUrl, TiktokFileType tiktokFileType) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToTwitter(String message, String? filePath) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  ///filepath only works for android
  Future<String> shareToTelegram(String message, {List<String>? filePaths}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToFacebook(String hashtag, List<String> filePaths) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToInstagramStory(String appId,
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
      {List<String>? filePaths}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  ///filePath only works for android
  Future<String> shareToSMS(String message, {List<String>? filePaths}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToWhatsappAndroid(
      String message, String? filePath) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToWhatsappAndroidMultiFiles(
      List<String> filePaths) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToTelegramAndroid(
      String message, String? filePath) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToTelegramAndroidMultiFiles(
      List<String> filePaths) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToTwitterAndroid(String message, String? filePath) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToTwitterAndroidMultifiles(List<String> filePaths) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToSMSAndroid(String message, String? filePath) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToSMSAndroidMultifiles(List<String> filePaths) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToSystemAndroid(
      String title, String message, String? filePath) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareImageToWhatsApp(String filePath) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToSystemAndroidMultifiles(
      String title, List<String> filePaths) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

enum TiktokFileType {
  image("image"),
  video("video");

  final String value;

  const TiktokFileType(this.value);
}
