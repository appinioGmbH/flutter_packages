import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'appinio_social_share_platform_interface.dart';

/// An implementation of [AppinioSocialSharePlatform] that uses method channels.
class MethodChannelAppinioSocialShare extends AppinioSocialSharePlatform {
  final String instagramDirect = "instagram_direct";
  final String instagramFeed = "instagram_post";
  final String instagramStories = "instagram_stories";
  final String facebook = "facebook";
  final String messenger = "messenger";
  final String facebookStories = "facebook_stories";
  final String whatsapp = "whatsapp";
  final String twitter = "twitter";
  final String sms = "sms";
  final String tiktokStatus = "tiktok_status";
  final String tiktokPost = "tiktok_post";
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
  Future<String> shareToTiktokStatus(String filePath) async {
    if (Platform.isIOS) return "Not implemented for iOS";
    return ((await methodChannel.invokeMethod<String>(
            tiktokStatus, {"imagePath": filePath, "message": ""})) ??
        "");
  }

  @override
  Future<String> shareToTiktokPost(String videoFile) async {
    if (Platform.isAndroid) return "Not implemented for android";
    return ((await methodChannel
            .invokeMethod<String>(tiktokPost, {"videoFile": videoFile})) ??
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
  Future<String> shareToInstagramDirect(String message) async {
    return ((await methodChannel
            .invokeMethod<String>(instagramDirect, {"message": message})) ??
        "");
  }

  @override
  Future<String> shareToInstagramFeed(String filePath) async {
    return ((await methodChannel.invokeMethod<String>(
            instagramFeed, {"imagePath": filePath, "message": ""})) ??
        "");
  }

  @override
  Future<String> shareToMessenger(String message) async {
    return ((await methodChannel
            .invokeMethod<String>(messenger, {"message": message})) ??
        "");
  }

  @override
  Future<String> shareToInstagramStory(String appId,
      {String? stickerImage,
      String? backgroundImage,
      String? backgroundVideo,
      String? backgroundTopColor,
      String? backgroundBottomColor,
      String? attributionURL}) async {
    return ((await methodChannel.invokeMethod<String>(instagramStories, {
          "stickerImage": stickerImage,
          "backgroundImage":
              backgroundImage ?? (Platform.isAndroid ? backgroundVideo : null),
          "videoFile": backgroundVideo,
          "backgroundTopColor": backgroundTopColor,
          "backgroundBottomColor": backgroundBottomColor,
          "attributionURL": attributionURL,
          "appId": appId
        })) ??
        "");
  }

  @override
  Future<String> shareToFacebookStory(String appId,
      {String? stickerImage,
      String? backgroundImage,
      String? backgroundVideo,
      String? backgroundTopColor,
      String? backgroundBottomColor,
      String? attributionURL}) async {
    return ((await methodChannel.invokeMethod<String>(facebookStories, {
          "stickerImage": stickerImage,
          "backgroundImage":
              backgroundImage ?? (Platform.isAndroid ? backgroundVideo : null),
          "videoFile": backgroundVideo,
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
