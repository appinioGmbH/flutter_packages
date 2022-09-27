package com.appinio.socialshare.appinio_social_share;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.appinio.socialshare.appinio_social_share.utils.SocialShareUtil;
import com.facebook.FacebookSdk;

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
    private final String INSTAGRAM = "instagram";
    private final String INSTAGRAM_STORIES = "instagram_stories";
    private final String FACEBOOK = "facebook";
    private final String MESSENGER = "messenger";
    private final String FACEBOOK_STORIES = "facebook_stories";
    private final String WHATSAPP = "whatsapp";
    private final String TWITTER = "twitter";
    private final String SMS = "sms";
    private final String TIKTOK = "tiktok";
    private final String SYSTEM_SHARE = "system_share";
    private final String COPY_TO_CLIPBOARD = "copy_to_clipboard";
    private final String TELEGRAM = "telegram";


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
        try{
            String response = decideApp(call, result);
            if (response != null) {
                result.success(response);
            }
        }catch (Exception e){
            Log.d("error",e.getLocalizedMessage());
            result.success(SocialShareUtil.ERROR);
        }

    }

    public String decideApp(@NonNull MethodCall call, @NonNull Result result) {
        activeContext = (activity != null) ? activity.getApplicationContext() : context;
        String title = call.argument("title");
        String message = call.argument("message");
        String facebookAppId = call.argument("appId");
        String imagePath = call.argument("imagePath");
        String stickerImage = call.argument("stickerImage");
        String attributionURL = call.argument("attributionURL");
        String backgroundImage = call.argument("backgroundImage");
        String backgroundTopColor = call.argument("backgroundTopColor");
        String backgroundBottomColor = call.argument("backgroundBottomColor");
        switch (call.method) {
            case INSTALLED_APPS:
                Map<String, Boolean> response =  socialShareUtil.getInstalledApps(activeContext);
                result.success(response);
                return null;
            case INSTAGRAM:
                return socialShareUtil.shareToInstagram(message,activeContext);
            case INSTAGRAM_STORIES:
                return socialShareUtil.shareToInstagramStory(stickerImage, backgroundImage, backgroundTopColor, backgroundBottomColor, attributionURL, activeContext);
            case FACEBOOK_STORIES:
                return socialShareUtil.shareToFaceBookStory(facebookAppId,stickerImage,backgroundImage, backgroundTopColor, backgroundBottomColor, attributionURL, activeContext);
             case MESSENGER:
                return socialShareUtil.shareToMessenger(message, activeContext);
            case FACEBOOK:
                if (activity == null) return SocialShareUtil.ERROR;
                socialShareUtil.shareToFacebook(imagePath, message, activity, result);
                return null;
            case WHATSAPP:
                return socialShareUtil.shareToWhatsApp(imagePath, message, activeContext);
            case TELEGRAM:
                return socialShareUtil.shareToTelegram(imagePath, activeContext, message);
            case TWITTER:
                return socialShareUtil.shareToTwitter(imagePath, activeContext, message);
            case COPY_TO_CLIPBOARD:
                return socialShareUtil.copyToClipBoard(message, activeContext);
            case SYSTEM_SHARE:
                return socialShareUtil.shareToSystem(title, message, imagePath, "image/*", title, context);
            case TIKTOK:
                return socialShareUtil.shareToTikTok(imagePath, activeContext, message);
            case SMS:
                return socialShareUtil.shareToSMS(message, activeContext,imagePath);
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
