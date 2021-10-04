# Appinio Animated Toggle Tab

A custom tab viewer with built-in animation.

## Preview

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/tab_toggle/example.gif?raw=true" height="400">

## Features

* a tabviewer ready to be customized
* built-in animation
* different design from default `TabViewer`

## Getting started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  appinio_tanimated_toggle_tab:
```

In your library add the following import:

```dart
import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.io/).

## Usage

You can place your `AppinioAnimatedToggleTab` inside of a `MaterialApp`, optional parameters can be defined to enable different featiures. See the following example

```dart
class OnBoarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: AppinioAnimatedToggleTab(
              callback: (int i) {},
              tabTexts: const [
                'make',
                'your',
                'tabs :)',
              ],
              height: 40,
              width: 300,
              boxDecoration: BoxDecoration(color: Color(0xFFc3d2db),),
              animatedBox: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              activeStyle: const TextStyle( color: Colors.blue,),
              inactiveStyle: const TextStyle( color: Colors.black,),
            );
  }
}
```

<hr/>
Made with ❤ by Flutter team at <a href="https://appinio.com">Appinio GmbH</a>
