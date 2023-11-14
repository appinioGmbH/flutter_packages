```appinio_swiper``` is a Flutter package for a Tinder Card Swiper. ✨

It allows swiping in all directions with any Custom Widget (Stateless or Statefull).

Very smooth animations supporting Android, iOS & WebApp.

## Why?

We build this package because we wanted to:

- have a complete customizable slider
- be able to swipe in every direction
- trigger unswipe however we want
- choose our own settings for the swiper such as duration, angle, padding..
- trigger swipe, swipe left/right or swipe up/down however we want
- set swipe options and restrict horizontal or vertical swipe.
- set loop for infinite scroll
- update the list of cards between swipes.
- Check in which direction the card is being swiped and modify your widget accordingly.- We can have any number of
  background cards.
- Pass any combination of swipe options.
- NEW - check when user is swiping card back before reaching the threshold value.
- NEW - Get current card index, offset and rotation
- NEW - Programmatically animate card swipe.
- NEW - We can have any number of background cards.
- NEW - Pass any combination of swipe options.

## ❗NEW  Features ❗

### Animate the top card.

Now you can arbitrarily animate the position of the top card using ```AppinioSwiperController.animatTo```.

### Listen to the card offset and rotation.

Now you can track the offset and rotation of the top card by listening to the ```AppinioSwiperController```.

### Know when user is coming back without completely swiping the card.

Now you can track if user is swiping the card back to the center with the ```CancelSwipe``` ```SwiperActivity```.

### Space background cards as per your requirement.

Now you can decide the spacing between the background cards and can also hide them by
giving   ```backgroundCardOffset = Offset.zero```.

### onSwipeCancelEvent.

We have added onSwipeCancel event to check if the card swiped completely or if the swipe got canceled in the middle.

### Add different combinations for swipe options.

Now you can provide any combination of swipe options. For example: The user can swipe to the left and bottom but not
top, or any possible combination.

### Show any number of background cards.

Now you can decide how many background cards you want to show.

### Listen to card swipes

Now you can check in which direction the card is being swiped and modify your widget accordingly

### Trigger swipe up and swipe down through controller

You can now trigger swipe up and swipe down with our ```AppinioSwiperController``` regardless of the chosen swipe
direction (which is still used when ```swipe``` is called through the controller). Just like the swipeLeft and
swipeRight call, you can call ```swipeUp``` or ```swipeDown``` through the controller anywhere you want.

### Restrict horizontal or vertical swipe

You can now restrict the swipe in either horizontal directions or vertical directions using ```swipeOptions``` property.

### Set looping for card swipe

Now you can set the ```loop``` property to ```true``` and make the list infinitely scrollable.

### Update the cards while swiping

In this version we have replaced the list of cards with ```cardsBuilder```. Now the widget only renders two cards at a
time which makes it lightweight and scalable. So you can perform operations on your card anytime.

## Show Cases

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/swiper/swiping.gif?raw=true" height="250" /> <img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/swiper/swipe_button.gif?raw=true" height="250" /> 

Trigger swipe right and swipe left however you want...

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/swiper/swipe_left_right.gif?raw=true" height="250" /> 

Unswipe the cards however you want...

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/swiper/unswipe.gif?raw=true" height="250" /> 

Customize the angle...

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/swiper/angle.gif?raw=true" height="250" />

Customize the threshold of the swiper, when the card should slide away...

<img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/swiper/treshold.gif?raw=true" height="250" />

## Installation

Create a new project with the command

```yaml
flutter create MyApp
```

Add

```yaml
appinio_swiper: ...
```

to your `pubspec.yaml` of your flutter project.
**OR**
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

You can place your `AppinioSwiper` inside of a `Scaffold` or `CupertinoPageScaffold` like we did here. Optional
parameters can be defined to enable different features. See the following example..

```dart
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';

class Example extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.75,
        child: AppinioSwiper(
          cardsCount: 10,
          onSwiping: (AppinioSwiperDirection direction) {
            print(direction.toString());
          },
          cardsBuilder: (BuildContext context, int index) {
            return Container(
              alignment: Alignment.center,
              child: const Text(index.toString()),
              color: CupertinoColors.activeBlue,
            );
          },
        ),
      ),
    );
  }
}
```

## Constructor

#### Basic

| Parameter        | Default                                            | Description                                                                                                                         | Required |
|------------------|:---------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------|:--------:|
| cardCount       | -                                                   | Number of cards you want to render.                                                                                                 |   true   |
| backgroundCardCount       | 1                                         | Number of cards you want to render in background.                                                                                   |  false   |
| backgroundCardScale       | .9                                        | Scale factor for the background card.                                                                                               |  false   |
| backgroundCardOffset      | -                                         | Offset for the background card.                                                                                                     |  false   |
| cardBuilder     | -                                                   | Callback of the type CardsBuilder.                                                                                                  |   true   |
| swipeOptions     | -                                                  | value of type AppinioSwipeOptions to restrict swipes.                                                                               |  false   |
| invertAngleOnBottomDrag     | true                                    | Sets whether the card should angle in the opposite direction when it is dragged from the bottom half.                               |  false   |
| controller       | -                                                  | Trigger swipe, unSwipe and animateTo.                                                                                               |  false   |
| padding          | EdgeInsets.symmetric(horizontal: 20, vertical: 25) | Control swiper padding                                                                                                              |  false   |
| duration         | 200 milliseconds                                   | The duration that every animation should last                                                                                       |  false   |
| cardsSpacing     | 40                                                 | The spacing between background cards.                                                                                               |  false   |
| maxAngle         | 30                                                 | Maximum angle the card reaches while swiping                                                                                        |  false   |
| threshold        | 50                                                 | Threshold from which the card is swiped away                                                                                        |  false   |
| isDisabled       | false                                              | Set to ```true``` if swiping should be disabled, has no impact when triggered from the outside                                      |  false   |
| onTapDisabled    | -                                                  | Function that get triggered when the swiper is disabled                                                                             |  false   |
| onSwipeBegin     | -                                                  | Called when user starts to swipe a card.                                                                                            |  false   |
| onSwipeEnd       | -                                                  | Called swipe action completes.                                                                                                      |  false   |
| onCardPositionChanged   | -                                           | Called when card position changes.                                                                                                  |  false   |
| onEnd            | -                                                  | Called when there is no Widget left to be swiped away                                                                               |  false   |
| defaultDirection        | right                                       | Direction in which the card is swiped away when triggered from the outside                                                          |  false   |
| allowUnswipe     | true                                               | Set to ```false``` if unswipe should be disabled away                                                                               |  false   |
| unlimitedUnswipe | false                                              | Set to ```true``` if the user can unswipe as many cards as possible                                                                 |  false   |
| onUnswipe          | -                                                  | Called with the boolean ```true``` when the last card gets unswiped and with the boolean ```false``` if there is no card to unswipe |  false   |
| onSwipeCancelled | -                                                  | Gets called when the user leaves the card before the threshold is reached                                                           |  false   |

#### Controller

The ```Controller``` is used to control the ```swipeDefault```, ```swipeLeft```, ```swipeRight```, ```swipeUp```
, ```swipeDown``` , ```unswipe```  and ```animateTo``` function of the swiper from outside of the widget. You can create a controller
called ```AppinioSwiperController``` and save the instance for further usage. Please have a closer look to our Example
for the usage.

| Method     | Description                                                                                        |
|------------|:---------------------------------------------------------------------------------------------------|
| swipe      | Changes the state of the controller to swipe and swipes the card in your selected direction.       |
| swipeLeft  | Changes the state of the controller to swipe left and swipes the card to the left side.            |
| swipeRight | Changes the state of the controller to swipe right and swipes the card to the right side.          |
| swipeUp    | Changes the state of the controller to swipe up and swipes the card to the up side.                |
| swipeDown  | Changes the state of the controller to swipe down and swipes the card to the down side.            |
| unswipe    | Changes the state of the controller to unswipe and brings back the last card that was swiped away. |
| animateTo    | Animates the current offset of the card on top to the required Offset in a given duration. |

<hr/>
Made with ❤ by Flutter team at <a href="https://appinio.app">Appinio GmbH</a>
