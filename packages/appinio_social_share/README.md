```appinio_social_share``` supports sharing files to social media (Facebook, Instagram, Instagram Story, Messenger, Telegram, WhatsApp, Twitter, Tiktok, SMS, System, etc.). If you want to share text, file, image, text with image or text with files then this plugin is all you need.

<br />


## Top Sharing Features

- Facebook Post
- Facebook Stories
- Instagram Chat
- Instagram Stories
- Messenger
- Telegram
- WhatsApp
- Twitter
- Tiktok
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
</queries>

<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" />

</manifest>
```

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


## Facebook features

### Working on both platform

```dart

shareToFacebook();
shareToFacebookStory();


```

## Instagram features

### Working on both platform

```dart

shareToInstagram();
shareToInstagramStory();

```

## Messenger features

### Working on both platform

```dart

shareToMessenger();


```

## Telegram features

### Working on both platform

```dart

shareToTelegram();


```

## WhatsApp features

### Working on both platform

```dart

shareToWhatsApp();

```

## Twitter features

### Working on both platform

```dart

shareToTwitter();

```

## Tiktok features : Only works for android currently

### Working on both platform

```dart

shareToTiktok();

```

## SMS features 

### Working on both platform

```dart

shareToSms();

```



## System share

### Working on both platform

```dart

shareToSystem();

```



## Copy To ClipBoard

### Working on both platform

```dart

copyToClipBoard();

```

## Installed Apps

### Working on both platform

```dart

getInstalledApps();

```

<br />

## Usage

```dart

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppinioSocialShare appinioSocialShare =  AppinioSocialShare();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Share Feature",
        home: Scaffold(
          body: Column(
            children: [
              ElevatedButton(
                  child: Text("ShareToWhatsapp"),
                  onPressed: () {
                    shareToWhatsApp("Message Text!!", file.getAbsolutePath());
                  })
            ],
          ),
        )
    );
  }


  Future<void> shareToWhatsApp(String message, String filePath) async{
    String response = await appinioSocialShare.shareToWhatsapp(message,filePath: filePath);
    print(response);
  }

}


```

<br />


| Method        | Parameters | Description
| ------------- |:-------------|:-------------
| getInstalledApps      |  -   | Get a Map of all the apps with a boolean value.
| shareToWhatsapp      | String message, {String? filePath} | Share Image and text to Whatsapp. For Ios only text works.
| shareToTelegram      | String message, {String? filePath} | Share Image and text to Telegram. For Ios only text works.
| shareToTwitter      | String message, {String? filePath} | Share Image and text to Twitter. Works for both the platforms.
| shareToInstagram      | String message | Share text message to Instagram. Works for both the platforms.
| shareToMessenger      | String message | Share text message to Messenger. Works for both the platforms.
| copyToClipBoard      | String message | To Copy text to clipboard. Works with both the platforms.
| shareToFacebook      | String message, String filePath | Share text hashtag and image to Facebook. Works for both the platforms.
| shareToInstagramStory      | String stickerImage,{String? backgroundImage, String? backgroundTopColor,String? backgroundBottomColor,String? attributionURL} | Share background image, movable sticker, background colors to Instagram Story.
| shareToFacebookStory      |String stickerImage,String appId,{String? backgroundImage, String? backgroundTopColor, String? backgroundBottomColor, String? attributionURL} | Share background image, movable sticker, background colors to Facebook Story.
| shareToTiktok      | String  filePath | Share background image, movable sticker, background colors to Tiktok Story. Works only for android
| shareToSystem      | String title,String message, {String? filePath} | Open default System sheet, to share text and image.
| shareToSMS      | String message, {String? filePath} | Share Image and text to default sms app. For Ios only text works.





<hr/>
Made with ❤ by Flutter team at <a href="https://appinio.com">Appinio GmbH</a>
