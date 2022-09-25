```Flutter OnBoarding Slider``` is a Flutter package containing a page slider with parallex design that allows (Text) widgets or body to slide at a different speed with background. ✨

Supporting Android, iOS.

## Why?

We build this package because we wanted to:

- have parralex design of the background that allows background to slide at a different speed.
- display with a bottom controller that indicates the current page.
- trigger `skip` with a button on the top right with a final function.

## Show Cases

#### Swipe
Touch swiping.

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/page_slider/swipe.gif?raw=true" height="400">

#### Slide
Swipe with the Floating Action Button.

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/page_slider/slide.gif?raw=true" height="400">


#### Skip
Skip to last Slide.

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/page_slider/skip.gif?raw=true" height="400">

## Installation

Create a new project with the command
```yaml
flutter create MyApp
```
Add
```yaml
dependencies:
  ...
  flutter_onboarding_slider:
```
to your `pubspec.yaml` of your flutter project.
**OR**
run

```yaml
flutter pub add flutter_onboarding_slider
```
in your project's root directory.

In your library add the following import:

```dart
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.io/).

## Usage
You can place your `OnBoardingSlider` inside of a `Scaffold` or `CupertinoApp` like we did here. Optional parameters can be defined to enable different features. See the following example..

```dart
class OnBoarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: OnBoardingSlider(
        headerBackgroundColor: Colors.white,
        finishButtonText: 'Register',
        skipTextButton: Text('Skip'),
        trailing: Text('Login'),
        background: [
          Image.asset('assets/slide_1.png'),
          Image.asset('assets/slide_2.png'),
        ],
        totalPage: 2,
        speed: 1.8,
        pageBodies: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text('Description Text 1'),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text('Description Text 2'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

## Constructor
#### Basic


| Parameter        | Default           | Description  | Required  |
| ------------- |:-------------|:-----|:-----:|
| headerBackgroundColor | - | color of the background | false |
| finishButtonText | - | Text inside last pages bottom button | false |
| skipTextButton | - | NavigationBar trailing widget when not on last screen | false |
| trailing | - | NavigationBar trailing widget when on last screen | false |
| background | - | List of Widgets to be shown in the backgrounds of the pages. For example a picture or some illustration | true |
| totalPage | - | Number of total pages | true |
| speed | - | The speed of the animation for the [background] | true |
| pageBodies | - | The main content ont the screen displayed above the [background] | true |


<hr/>
Made with ❤ by Flutter team at <a href="https://appinio.com">Appinio GmbH</a>