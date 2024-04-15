## [2.1.1] - 2024.04.15
* Bug fixes:
  - Swiper renders the topmost background card for all background positions Appinio swiper
  - _AppinioSwiperState#b3f89(tickers: tracking 1 ticker) was disposed with an active Ticker.
  - Failed assertion: line 314 pos 15: 'opacity >= 0.0 && opacity <= 1.0': is not true Appinio swiper
  - All background cards have the same style

## [2.1.0] - 2023.11.21
* Features:
  - The controller now exposes all relevant card state (index, card offset+rotation, etc).
  - The controller now has animateTo to arbitrarily animate the top card’s offset.
  - Added onSwipeEnd, onSwipeBegin and onCardPositionChanged methods to give the swipe information.
  - Added SwiperActivity class to give more information during card swipe.
  - Better documentation, linting and code formatting.

## [2.0.3] - 2023.08.23
* Features:
    - Custom background card spacing.
    - onSwipeCancelled event.



## [2.0.2] - 2023.06.19
* Features:
    - You can pass any combination of SwipeOptions.
    - You can decide how many background cards you need.


## [2.0.1] - 2023.05.31

* Features:
    - You can add a listener and check in which direction the card is being swiped.


## [2.0.0] - 2023.03.16

Features:
* Breaking change - Replaced the list of cards with cardsBuilder.
* Trigger swipe up & down through controller.
* Restrict horizontal or vertical swipe.
* Set looping for card swipe.
 
## [1.1.1] - 2022.10.13

Fixes:
* NoSuchMethodError When onSwipe method is not provided.

## [1.1.0] - 2022.09.11

Features:
* Detect the directi on (left, right, top, bottom) in which the card was swiped away.
* Unswipe all cards.

## [1.0.3] - 2022.04.28

* Trigger swipe through controller.

## [1.0.2] - 2021.12.8

* Bug fix.

## [1.0.1] - 2021.12.1

* Feature: Sending Feedback when widget is unswiped.

## [1.0.0] - 2021.11.26

* Initial version 
