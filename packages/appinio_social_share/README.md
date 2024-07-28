```appinio_social_share``` supports sharing files to social media (Facebook, Instagram, Instagram Story, Messenger, Telegram, WhatsApp, Twitter, Tiktok, SMS, System, etc.). If you want to share text, file, image, text with image or text with files then this plugin is all you need.

<br />


## Top Sharing Features

- Facebook Post
- Facebook Stories
- Instagram Chat
- Instgaram Feed
- Instgaram Reel
- Instagram Stories
- Messenger
- Telegram
- WhatsApp
- Twitter
- Tiktok Status
- Tiktok video
- SMS
- System ShareSheet
- Copy to clipboard
- Check if these apps are installed


## Some Example Previews

#Android 


<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/social_share/android.jpg?raw=true">

#iOS


<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/social_share/ios.jpg?raw=true">


**Simply use AppinioSocialShare class and call the method of which platform you want to share.

## Android

Paste the following attribute in the manifest tag in the AndroidManifest.xml

```xml

<manifest xmlns:tools="http://schemas.android.com/tools">
</manifest>
```

For example:

```xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          xmlns:tools="http://schemas.android.com/tools"
          package="your package...">
</manifest>
```

Add these permissions and queries to your AndroidManifest.xml

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:tools="http://schemas.android.com/tools"
        package="your package...">
  
<queries>
    <!-- Explicit apps you know in advance about: -->
          
    <package android:name="com.instagram.android" />
    <package android:name="com.zhiliaoapp.musically" />
    <package android:name="com.facebook.katana" />
    <package android:name="com.facebook.orca" />
    <package android:name="org.telegram.messenger" />
    <package android:name="com.whatsapp" />
    <package android:name="com.twitter.android" />
  
    <provider android:authorities="com.facebook.katana.provider.PlatformProvider" /> <!-- allows app to access Facebook app features -->
    <provider android:authorities="com.facebook.orca.provider.PlatformProvider" /> <!-- allows sharing to Messenger app -->
</queries>

  <!-- Required only if your app needs to access images or photos
       that other apps created. -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />

  <!-- Required only if your app needs to access videos
       that other apps created. -->
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />

  <!-- Required only if your app needs to access audio files
       that other apps created. -->
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />

<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>

<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
          android:maxSdkVersion="29" />
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" />

</manifest>
```

## NOTE: 

MANAGE_EXTERNAL_STORAGE requires additional permissions from google. So do not add it if you are not planning to access external storage.
Check this for more info. https://support.google.com/googleplay/android-developer/answer/10467955?hl=en


Create xml folder and add a provider path file to it (for example: provider_paths_app.xml) in android/app/src/main/res and 
add the lines below to the created xml file

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths>
    <external-path
        name="external_files"
        path="." />
</paths>
```

After created your own file provider and define your own path paste them into this and add to your AndroidManifest.xml

```xml

<provider android:name="androidx.core.content.FileProvider" 
        android:authorities="${applicationId}.provider"
    android:exported="false" android:grantUriPermissions="true">
    <meta-data android:name="android.support.FILE_PROVIDER_PATHS" android:resource="@xml/[your_custom_fileProvider_file_name]" />
</provider>
```

### Facebook app register

+ In /android/app/src/main/values folder create a strings.xml file and add your facebook app id and facebook client token.
+ To get the facebook client token: Open your app on Meta for developer ([link](https://developers.facebook.com)) > Settings > Advanced > Security >
  Application code
+ To get the facebook app id follow the Meta link above and go to your app Settings > Basic information > App ID

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="facebook_app_id">[facebook_app_id]</string>
    <string name="facebook_client_token">[facebook_client_token]</string>
</resources>
```

+ Add this inside the application tag in android manifest.

```xml
  <provider android:name="com.facebook.FacebookContentProvider" android:authorities="com.facebook.app.FacebookContentProvider[facebook_app_id]"
         android:exported="true" />
     <meta-data android:name="com.facebook.sdk.ApplicationId" android:value="@string/facebook_app_id" />
     <meta-data android:name="com.facebook.sdk.ClientToken" android:value="@string/facebook_client_token" />
     <meta-data android:name="com.facebook.sdk.ApplicationName" android:value="${applicationName}"/>
     <activity android:name="com.facebook.FacebookActivity" android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation" android:label="${applicationName}" />
```


+ After complete the step above add these xml tags to your AndroidManifest.xml


## iOS

***Open Xcode and change your deployment target to iOS 11***

Add these lines to your Info.plist file

```xml
<dict>
  <key>CFBundleURLTypes</key>
  <array>
  <dict>
      <key>CFBundleURLSchemes</key>
      <array>
          <string>fb[your_facebook_app_id]</string>
      </array>
  </dict>
  </array>
  
  <key>LSApplicationQueriesSchemes</key>
  <array>
  <string>instagram</string>
  <string>fb</string>
  <string>fbauth2</string>
  <string>fbshareextension</string>
  <string>fbapi</string>
  <string>facebook-reels</string>
  <string>facebook-stories</string>
  <string>fb-messenger-share-api</string>
  <string>fb-messenger</string>
  <string>tg</string>
  <string>whatsapp</string>
  <string>twitter</string>
  </array>
  
  <key>NSPhotoLibraryUsageDescription</key>
  <string>$(PRODUCT_NAME) needs permission to access photos and videos on your device</string>
  <key>NSMicrophoneUsageDescription</key>
  <string>$(PRODUCT_NAME) does not require access to the microphone.</string>
  <key>NSCameraUsageDescription</key>
  <string>$(PRODUCT_NAME) requires access to the camera.</string>
  <key>NSAppleMusicUsageDescription</key>
  <string>$(PRODUCT_NAME) requires access to play music</string>
  
  <key>FacebookAppID</key>
  <string>[your_facebook_app_id]</string>
  <key>FacebookClientToken</key>
  <string>[your_facebook_client_token]</string>
  <key>FacebookDisplayName</key>
  <string>[your_facebook_app_display_name]</string>
  
  <key>NSBonjourServices</key>
  <array>
  <string>_dartobservatory._tcp</string>
  </array>
</dict>
```

***The facebook app id and facebook client token you can get by complete the steps mentioned on Android config***

Add these lines to the AppDelegate.swift file

```
import FBSDKCoreKit

// Put these lines in the application function
FBSDKCoreKit.ApplicationDelegate.shared.application(
        application,
        didFinishLaunchingWithOptions: launchOptions
)
```

<br />

***If you want to share files to tiktok (iOS), you can follow the steps below. For sharing to android you don't need these steps.***

Step 1 - Install Tiktok Sdk

```
Add the library to your XCode project as a Swift Package:

1- In XCode, click File -> Add Packages...
2- Paste the repository URL: https://github.com/tiktok/tiktok-opensdk-ios
3- Select Dependency Rule -> Up to Next Major Version and input the major version you want (i.e. 2.2.0 You can find the latest release here.)
4- Select Add to Project -> Your project
5- Click Copy Dependency and select the TikTokOpenShareSDK, TiktokOpenCoreSdk libraries.

```

Step 2 - Configure your project

-Configure your Xcode project
-Open your Info.plist file and add or update the following key-value pairs:
-Add the following values to LSApplicationQueriesSchemes:
1. tiktokopensdk for Login Kit.
2. tiktoksharesdk for Share Kit.
3. snssdk1233 and snssdk1180 to check if TikTok is installed on your device.
4. Add TikTokClientKey key with your app's client key, obtained from the TikTok for Developers website, as the value.
5. Add your app's client key to CFBundleURLSchemes.
```plist
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>tiktokopensdk</string>
    <string>tiktoksharesdk</string>
    <string>snssdk1180</string>
    <string>snssdk1233</string>
</array>
<key>TikTokClientKey</key>
<string>$TikTokClientKey</string>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>$TikTokClientKey</string>
    </array>
  </dict>
</array>

```

Step 3 - Add the following code to your app's AppDelegate:

```swift

import UIKit
import Flutter
import TikTokOpenSDKCore
import TikTokOpenShareSDK
import Foundation
import Photos

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let cntrl : FlutterViewController = self.window?.rootViewController as! FlutterViewController
      let tiktok_channel = FlutterMethodChannel(name: "appinio_social_share_tiktok", binaryMessenger: cntrl.binaryMessenger)
          
      tiktok_channel.setMethodCallHandler(
        {
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          if call.method == "tiktok_post" {
              let args = call.arguments as? [String: Any?]
              self.shareVideoToTiktok(args: args!, result: result)
          }else{
               result("Not implemented!")
          }
        })
      

    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }



    
    override func application(_ app: UIApplication,open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if (TikTokURLHandler.handleOpenURL(url)) {
            return true
        }
        return false
    }
    
    override func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if (TikTokURLHandler.handleOpenURL(userActivity.webpageURL)) {
            return true
        }
        return false
    }
    
    
    func shareVideoToTiktok(args : [String: Any?],result: @escaping FlutterResult) {
        let videoFile = args["videoFile"] as? String
        let redirectUrl = args["redirectUrl"] as? String
        let fileType = args["fileType"] as? String
        let videoData = try? Data(contentsOf:  URL(fileURLWithPath: videoFile!)) as NSData
        

        PHPhotoLibrary.shared().performChanges({

            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
            let filePath = "\(documentsPath)/\(Date().description)" + (fileType == "image" ? ".jpeg" : ".mp4")

            videoData!.write(toFile: filePath, atomically: true)
            if fileType == "image" {
                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: URL(fileURLWithPath: filePath))

            }else {
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))

            }
        },
        completionHandler: { success, error in

            if success {

                let fetchOptions = PHFetchOptions()

                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

                let fetchResult = PHAsset.fetchAssets(with: fileType == "image" ? .image : .video, options: fetchOptions)

                if let lastAsset = fetchResult.firstObject {
                    let localIdentifier = lastAsset.localIdentifier
                    let shareRequest = TikTokShareRequest(localIdentifiers: [localIdentifier], mediaType: fileType == "image" ? .image : .video, redirectURI: redirectUrl!)
                    shareRequest.shareFormat = .normal
                    DispatchQueue.main.async {
                        shareRequest.send()
                        result("success")
                    }
                }
            }
            else if let error = error {

                print(error.localizedDescription)
            }
            else {

                result("Error getting the files!")
            }
        })
    }

}

private func registerPlugins(registry: FlutterPluginRegistry) {
}

```

Step 3 - Create a tiktok app on tiktok [developer portal] (https://developers.tiktok.com/apps/) and get a client key and add it in info.plist acc to step 2.

Obtain the [client_key](https://developers.tiktok.com/apps/) located in the Appdetails section of your app on the TikTok for Developers website. Then add Share Kit to your app by navigating to the Manage apps page, and clicking + Add products.

<img width="862" alt="Screenshot 2023-12-06 at 09 55 38" src="https://github.com/appinioGmbH/flutter_packages/assets/58891556/9b1f4d00-96ca-4496-91e8-6aa2b5b6c992">

Your app must have access to the user's photo library to successfully share videos to TikTok.

Done ✅  - Now shareToTiktokPost will start working for IOS as well.

## Usage

```dart

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppinioSocialShare appinioSocialShare = AppinioSocialShare();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Share Feature",
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text("ShareToWhatsapp"),
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(type: FileType.image, allowMultiple: false);
                  if (result != null && result.paths.isNotEmpty) {
                    shareToWhatsApp(
                        "message", result.paths[0]!);
                  }
                },
              ),
            ],
          ),
        ));
  }

  shareToWhatsApp(String message, String filePath) async {
    await appinioSocialShare.android.shareToSMS(message, filePath);
  }
}



```

<br />


| Method        | iOS | Android | Parameters                                                                                                                                                                    | Description
|:-------------|:-------------:|:-------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------
| getInstalledApps      |✔️|   ✔️    | -                                                                                                                                                                             | Get a Map of all the apps with a boolean value.
| shareToWhatsapp      |✔️|   ✔️    | String message, {List<String>? filePaths}                                                                                                                                     | Share Image and text to Whatsapp. For Ios only text works.
| shareToTelegram      |✔️|   ✔️    | String message, {List<String>? filePaths}                                                                                                                                     | Share Image and text to Telegram. For Ios only text works.
| shareToInstagramDirect      |✔️|   ✔️    | String message                                                                                                                                                                | Share text message to Instagram.
| shareToInstagramFeed      |✔️|   ✔️    | List<String> imagePaths                                                                                                                                                       | Share image to Instagram feed.
| shareToInstagramReel      |✔️|   ✔️    | List<String> videoPaths                                                                                                                                                       | Share video to Instagram Reel.
| shareToInstagramStory      |✔️|   ✔️    | String facebookAppId, String stickerImage,{String? backgroundImage,String? backgroundVideo,  String? backgroundTopColor,String? backgroundBottomColor,String? attributionURL} | Share background image, movable sticker, background colors to Instagram Story.
| shareToFacebook      |✔️|   ✔️    | String message, List<String> filePaths                                                                                                                                        | Share text hashtag and image to Facebook.
| shareToFacebookStory      |✔️|   ✔️    | String stickerImage,String appId,{String? backgroundImage, String? backgroundVideo, String? backgroundTopColor, String? backgroundBottomColor, String? attributionURL}        | Share background image, movable sticker, background colors to Facebook Story.
| shareToMessenger      |✔️|   ✔️    | String message                                                                                                                                                                | Share text message to Messenger.
| shareToTiktokStatus      |❌ |   ✔️    | List<String> filePaths                                                                                                                                                        | ShaShare image to Tiktok Story.
| shareToTiktokPost      |❌ |   ✔️    | String  videoPath                                                                                                                                                             | Share video to tiktok.
| shareToTwitter      |  ✔️   |   ✔️    | String message, {List<String>? filePaths}                                                                                                                                     | Share Image and text to Twitter.
| shareToSMS      |✔️|   ✔️    | String message, {List<String>? filePaths}                                                                                                                                     | Share Image and text to default sms app.
| copyToClipBoard      |✔️|   ✔️    | String message                                                                                                                                                                | To Copy text to clipboard.
| shareToSystem      |✔️|   ✔️    | String title,String message, {List<String>? filePaths}                                                                                                                        | Open default System sheet, to share text and image.
| shareImageToWhatsApp      |✔️|   ❌     | String filePaths                                                                                                                           | Share image to whatsapp





<hr/>
Made with ❤ by Flutter team at <a href="https://appinio.app">Appinio GmbH</a>
