//to call the swipe or unswipe function from outside of the appinio swiper
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';

/// A controller used to control an [AppinioSwiper],
///
/// The controller notifies listeners when a swipe starts and for each tick of a
/// swipe animation.
class AppinioSwiperController extends ChangeNotifier {
  AppinioSwiperState? state;

  AppinioSwiperWidgetState? _attachedSwiper;

  /// The current position of the card, either a result of a user drag and/or a
  /// swipe animation.
  ///
  /// This is 0 when there is no active swipe. It increments up to 1 during an
  /// active swipe and then resets to 0 when the swipe is complete.
  Offset get swipeProgress {
    _assertIsAttached();
    return _attachedSwiper!.progress;
  }

  int get currentIndex {
    _assertIsAttached();
    return _attachedSwiper!.currentIndex;
  }

  /// Swipe the card in the default direction.
  ///
  /// The default direction is set by the attached [AppinioSwiper] widget.
  void swipeDefault() {
    _assertIsAttached();
    state = AppinioSwiperState.swipe;
    _attachedSwiper!.onSwipeDefault();
    notifyListeners();
  }

  /// Swipe the card to the left side.
  void swipeLeft() {
    _assertIsAttached();
    state = AppinioSwiperState.swipeLeft;
    _attachedSwiper!.onSwipeLeft();
    notifyListeners();
  }

  /// Swipe the card to the right side.
  void swipeRight() {
    _assertIsAttached();
    state = AppinioSwiperState.swipeRight;
    _attachedSwiper!.onSwipeRight();
    notifyListeners();
  }

  /// Unswipe the card.
  void unswipe() {
    _assertIsAttached();
    state = AppinioSwiperState.unswipe;
    _attachedSwiper!.onUnSwipe();
    notifyListeners();
  }

  /// Swipe the card to the top.
  void swipeUp() {
    _assertIsAttached();
    state = AppinioSwiperState.swipeUp;
    _attachedSwiper!.onSwipeUp();
    notifyListeners();
  }

  /// Swipe the card to the bottom.
  void swipeDown() {
    _assertIsAttached();
    state = AppinioSwiperState.swipeDown;
    _attachedSwiper!.onSwipeDown();
    notifyListeners();
  }

  void attach(AppinioSwiperWidgetState swiper) {
    assert(
      _attachedSwiper == null,
      'Controller can only be attached to one swiper widget at a time.',
    );
    _attachedSwiper = swiper;
    swiper.currentOffset.addListener(notifyListeners);
  }

  void detach() {
    _attachedSwiper?.currentOffset.removeListener(notifyListeners);
    _attachedSwiper = null;
  }

  void _assertIsAttached() {
    assert(_attachedSwiper != null, 'Controller must be attached.');
  }
}
