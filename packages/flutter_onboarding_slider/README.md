# Flutter OnBoarding Slider

A page slider with parallex design that allows (Text) widgets or body to slide at a different speed with background.

## Preview
#### Swipe
Touch swiping.

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/page_slider/swipe.gif?raw=true" height="400">


#### Slide
Swipe with the Floating Action Button.

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/page_slider/slide.gif?raw=true" height="400">


#### Skip
Skip to last Slide.

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/page_slider/skip.gif?raw=true" height="400">

## Features

* Parralex design of the background that allows background to slide at a different speed.
* A bottom controller that indicates the current page.
* A bottom Floating Action Button in the end.
* A skip button on the top right with a final function.

## Getting started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  flutter_onboarding_slider:
```

In your library add the following import:

```dart
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.io/).

## Usage

You can place your `PageSlider` inside of a `MaterialApp`, optional parameters can be defined to enable different featiures. See the following example

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

<hr/>
Made with ❤ by Flutter team at <a href="https://appinio.com">Appinio GmbH</a>
