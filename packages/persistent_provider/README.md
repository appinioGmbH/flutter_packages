```persistent_provider``` is a small plugin which saves the state of your provider locally and loads it when app opens next time.

<br />


## Top Features

- Saves the state of your provider when you call notifylistener
- loads the state when app opens up



** Simply Extend PersistentProvider class while creating a provider instead of ChangeNotifier and implement the required methods.
** Do not add provider to your pubspec.yaml explicitely because persistent_provider already uses this as a dependency.

## Android

Paste the following attribute in the manifest tag in the AndroidManifest.xml

Add these permissions to your AndroidManifest.xml

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(
          title: 'Flutter Demo Home Page',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            UserCard(
              name: Provider.of<UserProvider>(context).name,
              age: 24,
              gender: "Male",
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .6,
              child: TextField(
                onChanged: (String value) {
                  Provider.of<UserProvider>(context, listen: false).name =
                      value;
                },
                decoration: const InputDecoration(hintText: "Enter new name"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}



```

<br />

*** Implement the provider like this.

```dart

class UserProvider extends PersistentProvider {
  String _name = '';

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  @override
  void fromJson(Map<String, dynamic> data) {
    _name = data['name'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {"name": _name};
  }
}


```


| Method        | iOS | Android | Parameters | Description
|:-------------|:-------------:|:-------------:|:-------------|:-------------
| initialize      |✔️| ✔️ |  -   | call this method on the first screen of your app to load the saved provider state.





<hr/>
Made with ❤ by Flutter team at <a href="https://appinio.com">Appinio GmbH</a>
