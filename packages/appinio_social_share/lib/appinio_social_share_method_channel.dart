import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'appinio_social_share_platform_interface.dart';

/// An implementation of [AppinioSocialSharePlatform] that uses method channels.
class MethodChannelAppinioSocialShare extends AppinioSocialSharePlatform {
  final String instagram = "instagram";
  final String instagramStories = "instagram_stories";
  final String facebook = "facebook";
  final String messenger = "messenger";
  final String facebookStories = "facebook_stories";
  final String whatsapp = "whatsapp";
  final String twitter = "twitter";
  final String sms = "sms";
  final String tiktok = "tiktok";
  final String systemShare = "system_share";
  final String copyToClipboard = "copy_to_clipboard";
  final String telegram = "telegram";
  final String installedApps = "installed_apps";

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('appinio_social_share');

  @override
  Future<Map> getInstalledApps() async {
    return await methodChannel.invokeMethod(installedApps);
  }

  @override
  Future<String> shareToTiktok(String filePath) async {
    return ((await methodChannel.invokeMethod<String>(
            tiktok, {"imagePath": filePath, "message": ""})) ??
        "");
  }

  @override
  Future<String> shareToTwitter(String message, {String? filePath}) async {
    return ((await methodChannel.invokeMethod<String>(
            twitter, {"imagePath": filePath, "message": message})) ??
        "");
  }

  @override
  Future<String> shareToTelegram(String message, {String? filePath}) async {
    return ((await methodChannel.invokeMethod<String>(
            telegram, {"imagePath": filePath, "message": message})) ??
        "");
  }

  @override
  Future<String> shareToWhatsapp(String message, {String? filePath}) async {
    return ((await methodChannel.invokeMethod<String>(
            whatsapp, {"imagePath": filePath, "message": message})) ??
        "");
  }

  @override
  Future<String> shareToSMS(String message, {String? filePath}) async {
    return ((await methodChannel.invokeMethod<String>(
            sms, {"message": message, "imagePath": filePath})) ??
        "");
  }

  @override
  Future<String> copyToClipBoard(String message) async {
    return ((await methodChannel
            .invokeMethod<String>(copyToClipboard, {"message": message})) ??
        "");
  }

  @override
  Future<String> shareToSystem(String title, String message,
      {String? filePath}) async {
    return ((await methodChannel.invokeMethod<String>(systemShare,
            {"message": message, "title": title, "imagePath": filePath})) ??
        "");
  }

  @override
  Future<String> shareToInstagram(String message) async {
    return ((await methodChannel
            .invokeMethod<String>(instagram, {"message": message})) ??
        "");
  }

  @override
  Future<String> shareToMessenger(String message) async {
    return ((await methodChannel
            .invokeMethod<String>(messenger, {"message": message})) ??
        "");
  }

  @override
  Future<String> shareToInstagramStory(
      {String? stickerImage,
      String? backgroundImage,
      String? backgroundTopColor,
      String? backgroundBottomColor,
      String? attributionURL}) async {
    return ((await methodChannel.invokeMethod<String>(instagramStories, {
          "stickerImage": stickerImage,
          "backgroundImage": backgroundImage,
          "backgroundTopColor": backgroundTopColor,
          "backgroundBottomColor": backgroundBottomColor,
          "attributionURL": attributionURL
        })) ??
        "");
  }

  @override
  Future<String> shareToFacebookStory(String appId,
      {String? stickerImage,
      String? backgroundImage,
      String? backgroundTopColor,
      String? backgroundBottomColor,
      String? attributionURL}) async {
    return ((await methodChannel.invokeMethod<String>(facebookStories, {
          "stickerImage": stickerImage,
          "backgroundImage": backgroundImage,
          "backgroundTopColor": backgroundTopColor,
          "backgroundBottomColor": backgroundBottomColor,
          "attributionURL": attributionURL,
          "appId": appId
        })) ??
        "");
  }

  @override
  Future<String> shareToFacebook(String hashtag, String filePath) async {
    return ((await methodChannel.invokeMethod<String>(
            facebook, {"imagePath": filePath, "message": hashtag})) ??
        "");
  }
}
