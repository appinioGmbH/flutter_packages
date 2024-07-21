import Flutter
import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import Photos



public class SwiftAppinioSocialSharePlugin: NSObject, FlutterPlugin, SharingDelegate {

    private let INSTAGRAM_DIRECT:String = "instagram_direct";
    private let INSTAGRAM_STORIES:String = "instagram_stories";
    private let INSTAGRAM_POST:String = "instagram_post";
    private let FACEBOOK:String = "facebook";
    private let FACEBOOK_STORIES = "facebook_stories";
    private let MESSENGER = "messenger";
    private let WHATSAPP:String = "whatsapp";
    private let WHATSAPP_IMG_IOS:String = "whatsapp_img_ios";
    private let TWITTER:String = "twitter";
    private let SMS:String = "sms";
    private let SYSTEM_SHARE:String = "system_share";
    private let COPY_TO_CLIPBOARD:String = "copy_to_clipboard";
    private let TELEGRAM:String = "telegram";
    private let INSTALLED_APPS:String = "installed_apps";


    var shareUtil = ShareUtil()
    var flutterResult: FlutterResult!


    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "appinio_social_share", binaryMessenger: registrar.messenger())
    let instance = SwiftAppinioSocialSharePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      do {
      flutterResult = result
      let args = call.arguments as? [String: Any?]

      switch (call.method) {
      case INSTALLED_APPS:
          shareUtil.getInstalledApps(result: result)
          break
      case INSTAGRAM_DIRECT:
          shareUtil.shareToInstagramDirect(args:args!,result: result)
          break
      case INSTAGRAM_POST:
          shareUtil.shareToInstagramFeed(args:args!,result: result)
          break
      case INSTAGRAM_STORIES:
          shareUtil.shareToInstagramStory(args:args!,result:result)
          break
      case FACEBOOK_STORIES:
          shareUtil.shareToFacebookStory(args:args!,result:result)
          break
      case WHATSAPP_IMG_IOS:
          shareUtil.shareImageToWhatsApp(args:args!, result:result,delegate: self)
          break
      case WHATSAPP:
          shareUtil.shareToWhatsApp(args:args!, result:result)
          break
      case TWITTER:
          shareUtil.shareToTwitter(args:args!,result:result)
          break
      case SMS:
          shareUtil.shareToSms(args: args!, result: result)
          break
      case SYSTEM_SHARE:
          shareUtil.shareToSystem(args:args!,result: result)
          break
      case COPY_TO_CLIPBOARD:
          shareUtil.copyToClipboard(args: args!, result: result)
          break
      case FACEBOOK:
          shareUtil.shareToFacebookPost(args:args!, result: result,delegate: self)
          break
      case TELEGRAM:
          shareUtil.shareToTelegram(args:args!, result:result)
          break
      case MESSENGER:
          shareUtil.shareToMessenger(args: args!, result: result)
          break
      default:
          result(shareUtil.ERROR)
      }
      } catch {
          result(shareUtil.ERROR)
      }
  }
    
    public func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        flutterResult(shareUtil.SUCCESS)
     }
     
     public func sharer(_ sharer: Sharing, didFailWithError error: Error) {
         flutterResult(shareUtil.ERROR)
     }
     
     public func sharerDidCancel(_ sharer: Sharing) {
         flutterResult(shareUtil.ERROR)
     }
    
    
     
}
