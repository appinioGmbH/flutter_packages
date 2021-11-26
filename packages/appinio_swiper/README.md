```appinio_swiper``` is a Flutter package for a Tinder Card Swiper. ✨

It allows swiping in all directions with every Custom Widget you want (Stateless or Statefull).

Very smooth animations supporting Android, iOS & WebApp.

## Why?

We build this package because we wanted to:

- have a complete customizable slider
- be able to swipe in every direction
- trigger unswipe however we want
- choose our own settings for the swiper such as duration, angle, padding..
- add functions while un-/swiping, on end or when the swiper is disabled

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/swiper/swipe1.gif?raw=true" height="400" /> <img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/swiper/swipe2.gif?raw=true" height="400" />

Trigger the unswipe however you want..

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/swiper/swipe3.gif?raw=true" height="400" /> <img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/swiper/swipe4.gif?raw=true" height="400" />

Customize the angle..

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/swiper/swipe6.gif?raw=true" height="400" />

Customize the threshold of the swiper, when the card should slide away..

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/swiper/swipe5.gif?raw=true" height="400" />

## Installation
Add
```yaml
appinio_swiper: ...
```
to your `pubspec.yaml` of your flutter project.
OR
run

```yaml
flutter pub add appinio_swiper
```
in your project's root directory.


In your library add the following import:

```dart
import 'package:appinio_swiper/appinio_swiper.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.io/).

## Usage
You can place your `AppinioSwiper` inside of a `Scaffold` or `CupertinoPageScaffold` like we did here. Optional parameters can be defined to enable different features. See the following example..

```dart
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Example extends StatelessWidget {
  List<Container> cards = [
    Container(
      alignment: Alignment.center,
      child: Text('1'),
      color: CupertinoColors.activeBlue,
    ),
    Container(
      alignment: Alignment.center,
      child: Text('2'),
      color: CupertinoColors.activeBlue,
    ),
    Container(
      alignment: Alignment.center,
      child: Text('3'),
      color: CupertinoColors.activeBlue,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: AppinioSwiper(
          cards: cards,
        ),
      ),
    );
  }
}
```

## Constructor
#### Basic


| Parameter        | Default           | Description  | Required  |
| ------------- |:-------------|:-----|:-----:|
| cards      | - | List of Widgets for the swiper | true
| controller      | - | Trigger unswipe | false
| padding      | EdgeInsets.symmetric(horizontal: 20, vertical: 25) | Control swiper padding | false
| duration      | 200 milliseconds    |   The duration that every animation should last | false
| maxAngle | 30      |    Maximum angle the card reaches while swiping | false
| threshold | 50     |    Threshold from which the card is swiped away | false
| isDisabled | false      |   Set to ```true``` when swiping should be disabled | false
| onTapDisabled | -     |    Function that get triggered when the swiper is disabled | false
| onSwipe | -    |    Called with the new index when the user swiped | false
| onEnd | -    |    Called when there is no Widget left to be swiped away | false

#### Controller

The ```Controller``` is used to control the ```unswipe``` function of the swiper from outside of the widget. You can create a controller called ```AppinioSwiperController``` and save the instance for further usage. Please have a closer look to our Example for the usage.

| Method        | Description
| ------------- |:-------------
| unswipe      | Changes the state of the controller to unswipe and brings back the last card that was swiped away.


<hr/>
Made with ❤ by Flutter team at <a href="https://appinio.com">Appinio GmbH</a>
