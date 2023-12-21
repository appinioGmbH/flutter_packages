```auth_check``` is a Flutter plugin to check if the app was installed using playstore. It helps developers to ensure that the login/Signup should not work if the app was not downloaded using playstore.

## Usage

You can call `checkAppAuth` method to get the result as a boolean.

```dart
  Future<void> _checkInstaller() async {
    bool? isInstalledByPlayStore = await AppAuthCheck().checkAppAuth();
    if (isInstalledByPlayStore != null) {
      setState(() {
        // do your action
      });
    }
  }
```
<hr/>
Made with ❤ by Flutter team at <a href="https://appinio.app">Appinio GmbH</a>
