import Flutter
import UIKit

public class SwiftDisableScreenshotPlugin: NSObject, FlutterPlugin {
  var eventSink: FlutterEventSink?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftDisableScreenshotPlugin()
    let methodChannel = FlutterMethodChannel(
        name: "com.appinio.screenshot/disableScreenshots", 
        binaryMessenger: registrar.messenger()
    )
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    
    let channel = FlutterEventChannel(
        name: "com.appinio.screenshot/observer", 
        binaryMessenger: registrar.messenger()
    )
    channel.setStreamHandler(instance)
  }
    
  @objc func callScreenshots() {
    eventSink!("")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        /*
        if call.method == "disableScreenshots" {
            if let arg = call.arguments as? Dictionary<String, Any>, let disable = arg["disable"] as? Bool {
                if disable {
                    //禁用截屏
                } else {
                    //允许截屏
                }
            } else {
                print("【SwiftDisableScreenshotsPlugin】disableScreenshots 收到错误参数")
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
        */
        result(FlutterMethodNotImplemented)
    }
}


extension SwiftDisableScreenshotPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(callScreenshots),
            name: UIApplication.userDidTakeScreenshotNotification,
            object: nil)
        
        return nil
    }
       
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
    }
}