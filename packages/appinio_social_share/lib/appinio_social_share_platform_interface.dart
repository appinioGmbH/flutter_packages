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

  Future<String> shareToInstagram(String message) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToMessenger(String message) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  ///This function only works for android
  Future<String> shareToTiktok(String filePath) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToTwitter(String message, {String? filePath}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  ///filepath only works for android
  Future<String> shareToTelegram(String message, {String? filePath}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToFacebook(String hashtag, String filePath) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToInstagramStory({String? stickerImage,
      String? backgroundImage,
      String? backgroundTopColor,
      String? backgroundBottomColor,
      String? attributionURL}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> shareToFacebookStory(String appId,
      {String? stickerImage,
      String? backgroundImage,
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
