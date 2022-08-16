package com.appinio.disable_screenshot

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.WindowManager
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import kotlin.coroutines.coroutineContext

/** DisableScreenshotsPlugin */
public class DisableScreenshotPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var applicationContext: Context;
  private lateinit var activity: Activity;
  private var eventSink: EventChannel.EventSink? = null
  private lateinit var screenShotListenManager: ScreenShotListenManager;
  var disableScreenshots: Boolean = false

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

    onAttachedToEngine(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
  }

  private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger) {
    this.applicationContext = applicationContext
    this.channel = MethodChannel(messenger, "com.appinio.screenshot/disableScreenshots")
    val eventChannel = EventChannel(messenger, "com.appinio.screenshot/observer")
    this.channel.setMethodCallHandler(this)
    eventChannel.setStreamHandler(this)
  }

  private fun setDisableScreenshotsStatus(disable: Boolean) {
    if (disable) {
      activity.window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE);
      println("disable screenshot")
    } else {
      activity.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
      println("allow screenshot")
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "disableScreenshots") {
      var disable = call.argument<Boolean>("disable") == true
      setDisableScreenshotsStatus(disable)
      result.success("")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    println("start listening")
    eventSink = events
    screenShotListenManager = ScreenShotListenManager.newInstance(applicationContext)
    screenShotListenManager.setListener { imagePath ->
      println("got screenshot with path：$imagePath")
      eventSink?.success("got screenshot")
    }
    screenShotListenManager.startListen()
  }

  override fun onCancel(arguments: Any?) {
    screenShotListenManager.stopListen()
    eventSink = null
  }


  override fun onDetachedFromActivity() {

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    setDisableScreenshotsStatus(this.disableScreenshots)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    setDisableScreenshotsStatus(this.disableScreenshots)
  }

  override fun onDetachedFromActivityForConfigChanges() {

  }
}
