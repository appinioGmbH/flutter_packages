```AppinioAnimatedToggleTab``` is a Flutter package for creating a custom tab viewer with built-in animation. ✨

Supporting Android, iOS & WebApp.

## Why?

We build this package because we wanted to:

- have a tabviewer ready to be customized
- be able to animate between switching tabs

## Show Cases

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/tab_toggle/example.gif?raw=true" height="400">

Switching between tabs.

## Installation

Create a new project with the command
```yaml
flutter create MyApp
```
Add
```yaml
dependencies:
  ...
  appinio_tanimated_toggle_tab:
```
to your `pubspec.yaml` of your flutter project.
**OR**
run

```yaml
flutter pub add appinio_tanimated_toggle_tab
```
in your project's root directory.


In your library add the following import:

```dart
import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.io/).

## Usage
You can place your `AppinioAnimatedToggleTab` inside of a `MaterialApp` like we did here. Optional parameters can be defined to enable different features. See the following example..

```dart
class TabsViewer extends StatelessWidget {
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
              animatedBoxDecoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFc3d2db).withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
                color: kDarkBlueColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              activeStyle: const TextStyle( color: Colors.blue,),
              inactiveStyle: const TextStyle( color: Colors.black,),
            );
  }
}
```

## Constructor
#### Basic


| Parameter        | Default           | Description  | Required  |
| ------------- |:-------------|:-----|:-----:|
| callback | - | function(int) for call back and control the view of tabs | true
| tabTexts | - | a list of texts displayed on the tabs | true
| height | - | height of the tab | true
| width | - | width of the tab | true
| boxDecoration | - | decoration of the tab | true
| animatedBoxDecoration | - | the decoration of animated box used to toggle | true
| activeStyle | - | style of text when active | true
| inactiveStyle | - | style of text when inactive | true


<hr/>
Made with ❤ by Flutter team at <a href="https://appinio.com">Appinio GmbH</a>