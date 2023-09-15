enum AppinioSwiperState {
  swipe,
  swipeLeft,
  swipeRight,
  unswipe,
  swipeUp,
  swipeDown
}

enum AppinioSwiperDirection { none, left, right, top, bottom, comingBack }

class AppinioSwipeOptions {
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  final bool horizontal;
  final bool vertical;
  final bool allDirections;

  const AppinioSwipeOptions.symmetric({
    this.horizontal = false,
    this.vertical = false,
  })  : left = false,
        top = false,
        right = false,
        bottom = false,
        allDirections =
            !((horizontal && !vertical) || (!horizontal && vertical));

  /// If horizontal and vertical both are true/false then simply make the allDirections true.

  const AppinioSwipeOptions.only({
    this.top = false,
    this.bottom = false,
    this.left = false,
    this.right = false,
  })  : horizontal = false,
        vertical = false,
        allDirections = (top && left && bottom && right) ||
            (!top && !left && !bottom && !right);

  /// If top, left, right, bottom all are true/false then simply make the allDirections true.

  const AppinioSwipeOptions.all()
      : top = false,
        bottom = false,
        left = false,
        right = false,
        horizontal = false,
        vertical = false,
        allDirections = true;
}
