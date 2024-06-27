package com.appinio.socialshare.appinio_social_share;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.appinio.socialshare.appinio_social_share.utils.SocialShareUtil;

import java.util.ArrayList;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * AppinioSocialSharePlugin
 */
public class AppinioSocialSharePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

    private final String INSTALLED_APPS = "installed_apps";
    private final String INSTAGRAM_DIRECT = "instagram_direct";
    private final String INSTAGRAM_FEED = "instagram_post";
    private final String INSTAGRAM_FEED_FILES = "instagram_post_files";
    private final String INSTAGRAM_STORIES = "instagram_stories";
    private final String FACEBOOK = "facebook";
    private final String MESSENGER = "messenger";
    private final String FACEBOOK_STORIES = "facebook_stories";
    private final String WHATSAPP_ANDROID = "whatsapp_android";
    private final String WHATSAPP_ANDROID_MULTIFILES = "whatsapp_android_multifiles";
    private final String TWITTER_ANDROID = "twitter_android";
    private final String TWITTER_ANDROID_MULTIFILES = "twitter_android_multifiles";
    private final String SMS_ANDROID = "sms_android";
    private final String SMS_ANDROID_MULTIFILES = "sms_android_multifiles";
    private final String TIKTOK = "tiktok_status";
    private final String SYSTEM_SHARE_ANDROID = "system_share_android";
    private final String SYSTEM_SHARE_ANDROID_MULTIFILES = "system_share_android_multifiles";
    private final String COPY_TO_CLIPBOARD = "copy_to_clipboard";
    private final String TELEGRAM_ANDROID = "telegram_android";
    private final String TELEGRAM_ANDROID_MULTIFILES = "telegram_android_multifiles";


    private SocialShareUtil socialShareUtil;
    private MethodChannel channel;
    private Activity activity;
    private Context activeContext;
    private Context context;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "appinio_social_share");
        channel.setMethodCallHandler(this);
        socialShareUtil = new SocialShareUtil();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        try {
            String response = decideApp(call, result);
            if (response != null) {
                result.success(response);
            }
        } catch (Exception e) {
            Log.d("error", e.getLocalizedMessage());
            result.success(e.getLocalizedMessage());
        }

    }

    public String decideApp(@NonNull MethodCall call, @NonNull Result result) {
        activeContext = (activity != null) ? activity.getApplicationContext() : context;
        String title = call.argument("title");
        String message = call.argument("message");
        String appId = call.argument("appId");
        ArrayList<String> imagePaths = call.argument("imagePaths");
        String stickerImage = call.argument("stickerImage");
        String imagePath = call.argument("imagePath");
        String attributionURL = call.argument("attributionURL");
        String backgroundImage = call.argument("backgroundImage");
        String backgroundTopColor = call.argument("backgroundTopColor");
        String backgroundBottomColor = call.argument("backgroundBottomColor");
        switch (call.method) {
            case INSTALLED_APPS:
                Map<String, Boolean> response = socialShareUtil.getInstalledApps(activeContext);
                result.success(response);
                return null;
            case INSTAGRAM_DIRECT:
                return socialShareUtil.shareToInstagramDirect(message, activeContext);
            case INSTAGRAM_FEED:
                return socialShareUtil.shareToInstagramFeed(imagePath, message, activeContext, message);
            case INSTAGRAM_FEED_FILES:
                return socialShareUtil.shareToInstagramFeedFiles(imagePaths, activeContext,message);
            case INSTAGRAM_STORIES:
                return socialShareUtil.shareToInstagramStory(appId, stickerImage, backgroundImage, backgroundTopColor, backgroundBottomColor, attributionURL, activeContext);
            case FACEBOOK_STORIES:
                return socialShareUtil.shareToFaceBookStory(appId, stickerImage, backgroundImage, backgroundTopColor, backgroundBottomColor, attributionURL, activeContext);
            case MESSENGER:
                return socialShareUtil.shareToMessenger(message, activeContext);
            case FACEBOOK:
                if (activity == null) return SocialShareUtil.UNKNOWN_ERROR;
                socialShareUtil.shareToFacebook(imagePaths, message, activity, result);
                return null;
            case WHATSAPP_ANDROID:
                return socialShareUtil.shareToWhatsApp(imagePath, message, activeContext);
            case WHATSAPP_ANDROID_MULTIFILES:
                return socialShareUtil.shareToWhatsAppFiles(imagePaths, activeContext);
            case TELEGRAM_ANDROID:
                return socialShareUtil.shareToTelegram(imagePath, activeContext, message);
            case TELEGRAM_ANDROID_MULTIFILES:
                return socialShareUtil.shareToTelegramFiles(imagePaths, activeContext);
            case TWITTER_ANDROID:
                return socialShareUtil.shareToTwitter(imagePath, activeContext, message);
            case TWITTER_ANDROID_MULTIFILES:
                return socialShareUtil.shareToTwitterFiles(imagePaths, activeContext);
            case COPY_TO_CLIPBOARD:
                return socialShareUtil.copyToClipBoard(message, activeContext);
            case SYSTEM_SHARE_ANDROID:
                return socialShareUtil.shareToSystem(title, message, imagePath, title, context);
            case SYSTEM_SHARE_ANDROID_MULTIFILES:
                return socialShareUtil.shareToSystemFiles(title, imagePaths, title, context);
            case TIKTOK:
                return socialShareUtil.shareToTikTok(imagePaths, activeContext);
            case SMS_ANDROID:
                return socialShareUtil.shareToSMS(message, activeContext, imagePath);
            case SMS_ANDROID_MULTIFILES:
                return socialShareUtil.shareToSMSFiles(activeContext, imagePaths);
            default:
                return null;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();

    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();

    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }
}
