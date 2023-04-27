```persistent_provider``` is a small plugin which saves the state of your provider locally and loads it when app opens next time.

<br />


## Top Features

- Saves the state of your provider when you call notifylistener
- loads the state when app opens up



** Simply Extend PersistentProvider class while creating a provider instead of ChangeNotifier and implement the required methods.

## Android

Paste the following attribute in the manifest tag in the AndroidManifest.xml

Add these permissions and queries to your AndroidManifest.xml

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:tools="http://schemas.android.com/tools"
        package="your package...">

<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

</manifest>
```

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
                  },
              ),
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


| Method        | iOS | Android | Parameters | Description
|:-------------|:-------------:|:-------------:|:-------------|:-------------
| initialize      |✔️| ✔️ |  -   | call this method on the first screen of your app to load the saved provider state.





<hr/>
Made with ❤ by Flutter team at <a href="https://appinio.com">Appinio GmbH</a>
