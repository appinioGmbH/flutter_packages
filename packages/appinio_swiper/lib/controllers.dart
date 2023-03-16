//to call the swipe or unswipe function from outside of the appinio swiper
import 'package:flutter/cupertino.dart';

import 'enums.dart';

class AppinioSwiperController extends ChangeNotifier {
  AppinioSwiperState? state;

  //swipe the card by changing the status of the controller
  void swipe() {
    state = AppinioSwiperState.swipe;
    notifyListeners();
  }

  //swipe the card to the left side by changing the status of the controller
  void swipeLeft() {
    state = AppinioSwiperState.swipeLeft;
    notifyListeners();
  }

  //swipe the card to the right side by changing the status of the controller
  void swipeRight() {
    state = AppinioSwiperState.swipeRight;
    notifyListeners();
  }

  //calls unswipe the card by changing the status of the controller
  void unswipe() {
    state = AppinioSwiperState.unswipe;
    notifyListeners();
  }

  //swipe the card to the top by changing the status of the controller
  void swipeUp() {
    state = AppinioSwiperState.swipeUp;
    notifyListeners();
  }

  //swipe the card to the bottom by changing the status of the controller
  void swipeDown() {
    state = AppinioSwiperState.swipeDown;
    notifyListeners();
  }
}
