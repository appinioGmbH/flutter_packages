import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'appinio_social_share_platform_interface.dart';

/// An implementation of [AppinioSocialSharePlatform] that uses method channels.
class MethodChannelAppinioSocialShare extends AppinioSocialSharePlatform {
  final String instagramDirect = "instagram_direct";
  final String instagramFeed = "instagram_post";
  final String instagramFeedFiles = "instagram_post_files";
  final String instagramStories = "instagram_stories";
  final String facebook = "facebook";
  final String messenger = "messenger";
  final String facebookStories = "facebook_stories";
  final String whatsapp = "whatsapp";
  final String whatsappAndroid = "whatsapp_android";
  final String whatsappAndroidMultiFiles = "whatsapp_android_multifiles";
  final String twitter = "twitter";
  final String twitterAndroid = "twitter_android";
  final String twitterAndroidMultiFiles = "twitter_android_multifiles";
  final String sms = "sms";
  final String smsAndroid = "sms_android";
  final String smsAndroidMultiFiles = "sms_android_multifiles";
  final String tiktokStatus = "tiktok_status";
  final String tiktokPost = "tiktok_post";
  final String systemShare = "system_share";
  final String systemShareAndroid = "system_share_android";
  final String systemShareAndroidMultiFiles = "system_share_android_multifiles";
  final String copyToClipboard = "copy_to_clipboard";
  final String telegram = "telegram";
  final String telegramAndroid = "telegram_android";
  final String telegramAndroidMultiFiles = "telegram_android_multifiles";
  final String installedApps = "installed_apps";
  final String whatsappImgIos = "whatsapp_img_ios";

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('appinio_social_share');

  @override
  Future<Map<String, bool>> getInstalledApps() async {
    return Map<String, bool>.from(
        (await methodChannel.invokeMethod(installedApps)));
  }

  @override
  Future<String> shareToTiktokStatus(List<String> filePaths) async {
    if (Platform.isIOS) return "Not implemented for iOS";
    return ((await methodChannel.invokeMethod<String>(
            tiktokStatus, {"imagePaths": filePaths, "message": ""})) ??
        "");
  }

  @override
  Future<String> shareToTiktokPost(String filePath, String redirectUrl,
      TiktokFileType tiktokFileType) async {
    if (Platform.isAndroid) return "Not implemented for android";
    String? resp;
    try {
      resp = (await const MethodChannel('appinio_social_share_tiktok')
              .invokeMethod<String>(tiktokPost, {
            "videoFile": filePath,
            "redirectUrl": redirectUrl,
            "fileType": tiktokFileType.value
          })) ??
          "";
    } catch (e) {
      return e.toString();
    }
    return resp;
  }

  @override
  Future<String> shareToTwitter(String message, String? filePath) async {
    return ((await methodChannel.invokeMethod<String>(twitter, {
          "imagePaths": filePath == null ? [] : [filePath],
          "message": message
        })) ??
        "");
  }

  @override
  Future<String> shareToTwitterAndroid(String message, String? filePath) async {
    return ((await methodChannel.invokeMethod<String>(
            twitterAndroid, {"imagePath": filePath, "message": message})) ??
        "");
  }

  @override
  Future<String> shareToTwitterAndroidMultifiles(List<String> filePaths) async {
    return ((await methodChannel.invokeMethod<String>(
            twitterAndroidMultiFiles, {"imagePaths": filePaths})) ??
        "");
  }

  @override
  Future<String> shareToTelegram(String message,
      {List<String>? filePaths}) async {
    return ((await methodChannel.invokeMethod<String>(
            telegram, {"imagePaths": filePaths, "message": message})) ??
        "");
  }

  @override
  Future<String> shareToTelegramAndroid(
      String message, String? filePath) async {
    return ((await methodChannel.invokeMethod<String>(telegramAndroid, {
          "imagePath": filePath,
          "message": message,
        })) ??
        "");
  }

  @override
  Future<String> shareToTelegramAndroidMultiFiles(
      List<String> filePaths) async {
    return ((await methodChannel
            .invokeMethod<String>(telegramAndroidMultiFiles, {
          "imagePaths": filePaths,
        })) ??
        "");
  }

  ///for iOS only
  @override
  Future<String> shareToWhatsapp(String message,
      {List<String>? filePaths}) async {
    return ((await methodChannel.invokeMethod<String>(
            whatsapp, {"imagePaths": filePaths, "message": message})) ??
        "");
  }

  @override
  Future<String> shareToWhatsappAndroid(
      String message, String? filePath) async {
    return ((await methodChannel.invokeMethod<String>(
            whatsappAndroid, {"imagePath": filePath, "message": message})) ??
        "");
  }

  @override
  Future<String> shareToWhatsappAndroidMultiFiles(
      List<String> filePaths) async {
    return ((await methodChannel.invokeMethod<String>(
            whatsappAndroidMultiFiles, {"imagePaths": filePaths})) ??
        "");
  }

  @override
  Future<String> shareToSMS(String message, {List<String>? filePaths}) async {
    return ((await methodChannel.invokeMethod<String>(
            sms, {"message": message, "imagePaths": filePaths})) ??
        "");
  }

  @override
  Future<String> shareToSMSAndroid(String message, String? filePath) async {
    return ((await methodChannel.invokeMethod<String>(
            smsAndroid, {"message": message, "imagePath": filePath})) ??
        "");
  }

  @override
  Future<String> shareToSMSAndroidMultifiles(List<String> filePaths) async {
    return ((await methodChannel.invokeMethod<String>(
            smsAndroidMultiFiles, {"imagePaths": filePaths})) ??
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
      {List<String>? filePaths}) async {
    return ((await methodChannel.invokeMethod<String>(systemShare,
            {"message": message, "title": title, "imagePaths": filePaths})) ??
        "");
  }

  @override
  Future<String> shareToSystemAndroid(
      String title, String message, String? filePath) async {
    return ((await methodChannel.invokeMethod<String>(systemShareAndroid,
            {"message": message, "title": title, "imagePath": filePath})) ??
        "");
  }

  @override
  Future<String> shareToSystemAndroidMultifiles(
      String title, List<String> filePaths) async {
    return ((await methodChannel.invokeMethod<String>(
            systemShareAndroidMultiFiles,
            {"title": title, "imagePaths": filePaths})) ??
        "");
  }

  @override
  Future<String> shareToInstagramDirect(String message) async {
    return ((await methodChannel
            .invokeMethod<String>(instagramDirect, {"message": message})) ??
        "");
  }

  @override
  Future<String> shareToInstagramFeed(String message, String? filePath) async {
    return ((await methodChannel.invokeMethod<String>(
            instagramFeed, {"imagePath": filePath, "message": message})) ??
        "");
  }

  @override
  Future<String> shareToInstagramFeedAndroid(List<String> filePaths) async {
    return ((await methodChannel.invokeMethod<String>(instagramFeedFiles, {
          "imagePaths": filePaths,
        })) ??
        "");
  }

  @override
  Future<String> shareToMessenger(String message) async {
    return ((await methodChannel
            .invokeMethod<String>(messenger, {"message": message})) ??
        "");
  }

  @override
  Future<String> shareImageToWhatsApp(
    String filePath,
  ) async {
    return ((await methodChannel
            .invokeMethod<String>(whatsappImgIos, {"imagePath": filePath})) ??
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
  Future<String> shareToFacebook(String hashtag, List<String> filePaths) async {
    return ((await methodChannel.invokeMethod<String>(
            facebook, {"imagePaths": filePaths, "message": hashtag})) ??
        "");
  }
}
