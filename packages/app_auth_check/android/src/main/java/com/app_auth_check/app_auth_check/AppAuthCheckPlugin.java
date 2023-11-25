package com.app_auth_check.app_auth_check;
import android.app.Activity;
import android.content.Context;
import android.content.pm.InstallSourceInfo;
import android.os.Build;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** AppAuthCheckPlugin */
public class AppAuthCheckPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context activeContext;
  private Context context;
  private Activity activity;

  private String APP_AUTH_CHECK = "app_auth_check";


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "app_auth_check");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    activeContext = (activity != null) ? activity.getApplicationContext() : context;
    if (call.method.equals(APP_AUTH_CHECK)) {
      String pkgName = getInstallerPackageName(context,activeContext.getPackageName());
      if ("com.android.vending".equals(pkgName)) {
        result.success(true);
      }else{
        result.success(false);
      }
    } {
      result.notImplemented();
    }
  }

  public static String getInstallerPackageName(Context context, String packageName) {
    try {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
        InstallSourceInfo packageInfo = context.getPackageManager()
                .getInstallSourceInfo(packageName);
        return packageInfo.getInstallingPackageName();
      }
      // Suppress deprecation warning for getInstallerPackageName()
      @SuppressWarnings("deprecation")
      String installerPackageName = context.getPackageManager()
              .getInstallerPackageName(packageName);
      return installerPackageName;
    } catch (Exception e) {
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
