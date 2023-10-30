import 'package:flutter/material.dart';

sealed class SwiperActivity extends Tween<Offset> {
  SwiperActivity(
    this.animation, {
    required super.begin,
    required super.end,
  });

  final AnimationController animation;

  Offset get currentOffset => evaluate(animation);

  AxisDirection get direction {
    return (end! - begin!).toAxisDirection();
  }
}

class Swipe extends SwiperActivity {
  Swipe(
    super.animation, {
    required super.begin,
    required super.end,
  });
}

class Unswipe extends SwiperActivity {
  Unswipe(
    super.animation, {
    required super.begin,
  }) : super(end: Offset.zero);

  @override
  AxisDirection get direction => super.direction.opposite;
}

class CancelSwipe extends SwiperActivity {
  CancelSwipe(
    super.animation, {
    required super.begin,
  }) : super(end: Offset.zero);

  @override
  AxisDirection get direction => super.direction.opposite;
}

class DrivenActivity extends SwiperActivity {
  DrivenActivity(
    super.animation, {
    required this.curve,
    required super.begin,
    required super.end,
  });

  final Curve curve;

  late final Animation<double> curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: curve,
  );

  @override
  Offset get currentOffset => evaluate(curvedAnimation);
}

class SwipeOptions {
  final bool up;
  final bool down;
  final bool left;
  final bool right;

  const SwipeOptions.symmetric({
    bool horizontal = false,
    bool vertical = false,
  })  : up = vertical,
        down = vertical,
        left = horizontal,
        right = horizontal;

  /// If horizontal and vertical both are true/false then simply make the allDirections true.
  const SwipeOptions.only({
    this.up = false,
    this.down = false,
    this.left = false,
    this.right = false,
  });

  /// If top, left, right, bottom all are true/false then simply make the allDirections true.
  const SwipeOptions.all()
      : up = true,
        down = true,
        left = true,
        right = true;
}

extension DirectionUtils on AxisDirection {
  bool get isVertical => this == AxisDirection.up || this == AxisDirection.down;

  bool get isHorizontal => !isVertical;

  AxisDirection get opposite => switch (this) {
        AxisDirection.up => AxisDirection.down,
        AxisDirection.down => AxisDirection.up,
        AxisDirection.left => AxisDirection.right,
        AxisDirection.right => AxisDirection.left,
      };
}

extension OffsetUtils on Offset {
  Alignment toAlignment(Size size) {
    return Alignment(
      2 * (dx / size.width) - 1,
      2 * (dy / size.height) - 1,
    );
  }

  AxisDirection toAxisDirection() {
    if (dx.abs() >= dy.abs()) {
      if (dx.isNegative) {
        return AxisDirection.left;
      }
      return AxisDirection.right;
    }
    if (dy.isNegative) {
      return AxisDirection.up;
    }
    return AxisDirection.down;
  }
}
