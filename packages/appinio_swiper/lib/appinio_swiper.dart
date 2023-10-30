import 'dart:collection';
import 'dart:math';

import 'package:appinio_swiper/types.dart';
import 'package:flutter/material.dart';

import 'enums.dart';

export 'enums.dart';
export 'types.dart';

class AppinioSwiper extends StatefulWidget {
  /// A callback that's called when the user lifts their finger during a drag
  /// without having reached [threshold].
  final VoidCallback? onSwipeCancelled;

  /// The indexed widget builder that builds a card for the given index.
  final IndexedWidgetBuilder cardsBuilder;

  /// The number of cards in the stack.
  final int cardCount;

  /// Cards spacing.
  final double cardsSpacing;

  /// Background cards count
  final int backgroundCardCount;

  /// The amount to scale each successive background card down by,
  ///
  /// The difference in scale for each background card is a fixed amount
  /// relative to the original card.
  ///
  /// Defaults to .9.
  final double backgroundCardScale;

  /// The amount to offset each successive background card relative to the card
  /// before it.
  ///
  /// Defaults to offsetting each card down by 40 dp.
  final Offset? backgroundCardOffset;

  /// A controller that provides programmatic control of the swiper and notifies
  /// on swiper state changes.
  final AppinioSwiperController? controller;

  /// The duration of swipe animations.
  ///
  /// Swipe animations start after the user lifts their finger or when a drag
  /// is triggered by [AppinioSwiperController].
  final Duration duration;

  /// A callback that is called whenever the card moves.
  final void Function(AxisDirection direction, Offset position)?
      onCardPositionChanged;

  /// The maximum angle the card reaches while horizontally swiping.
  ///
  /// Cards lean in the direction of the swipe to sell their physicality. Set
  /// this to 0 to disable the lean.
  final double maxAngle;

  /// Sets whether the card should angle in the opposite direction when it is
  /// dragged from the bottom half.
  ///
  /// Defaults to true.
  final bool invertAngleOnBottomDrag;

  /// What swipe directions to allow.
  ///
  /// Swipes triggered by a controller are always allowed and are not affected
  /// by [swipeOptions].
  final SwipeOptions swipeOptions;

  /// The minimum distance a user has to pan the card before triggering a swipe
  /// animation.
  ///
  /// If a pan is less than [threshold] the card will animate back to it's
  /// original position and the card stack will not change.
  final double threshold;

  /// Set to true to disable swiping.
  final bool isDisabled;

  /// Set to true if you want the card stack to loop back to the beginning when
  /// the user swipes to the end.
  ///
  /// The looped cards will be displayed under the foreground card as if
  final bool loop;

  /// Callback that fires with the direction and new index whenever a swipe is
  /// triggered by the user or the [controller].
  final OnSwipe? onSwipe;

  /// Function that is called when the card stack runs out of cards.
  final VoidCallback? onEnd;

  /// Function that is called when a user attempts to swipe but swiping is
  /// disabled.
  final VoidCallback? onTapDisabled;

  /// Function that gets called when an unswipe is triggered.
  ///
  /// This is called with a boolean flag that is true if the unswipe was
  /// successful and false if it was not (there was no swipe to undo).
  final OnUnSwipe? unswipe;

  /// The default direction in which the card gets swiped when triggered by
  /// controller.
  ///
  /// Defaults to [AxisDirection.right].
  final AxisDirection defaultDirection;

  const AppinioSwiper({
    Key? key,
    required this.cardsBuilder,
    required this.cardCount,
    this.controller,
    this.duration = const Duration(milliseconds: 200),
    this.maxAngle = 30,
    this.invertAngleOnBottomDrag = true,
    this.cardsSpacing = 40,
    this.threshold = 50,
    this.backgroundCardCount = 1,
    this.backgroundCardScale = .9,
    this.backgroundCardOffset,
    this.isDisabled = false,
    this.loop = false,
    this.swipeOptions = const SwipeOptions.all(),
    this.onTapDisabled,
    this.onSwipe,
    this.onSwipeCancelled,
    this.onCardPositionChanged,
    this.onEnd,
    this.unswipe,
    this.defaultDirection = AxisDirection.right,
  })  : assert(maxAngle >= 0),
        assert(threshold >= 1 && threshold <= 100),
        super(key: key);

  @override
  State createState() => _AppinioSwiperState();
}

class _AppinioSwiperState extends State<AppinioSwiper>
    with TickerProviderStateMixin {
  static const _defaultBackgroundCardOffset = Offset(0, 40);

  double get _effectiveScaleIncrement => 1 - widget.backgroundCardScale;

  Offset get _effectiveOffset =>
      widget.backgroundCardOffset ?? _defaultBackgroundCardOffset;

  SwiperActivity? _swipeActivity;

  AnimationController get _defaultAnimation => AnimationController(
        vsync: this,
        duration: widget.duration,
      );

  late SwiperPosition position = SwiperPosition(
    cardSize: MediaQuery.sizeOf(context),
    cardCount: widget.cardCount,
    threshold: widget.threshold,
    maxAngleRadians: widget.maxAngle,
    invertAngleOnBottomDrag: widget.invertAngleOnBottomDrag,
    loop: widget.loop,
  );

  // Keep track of the swiped items to unswipe from the same direction
  final Queue<Swipe> _activityHistory = Queue();

  Future<void> _onSwipe(AxisDirection direction) async {
    if (position.index == widget.cardCount) {
      widget.onEnd?.call();
      return;
    }
    final Swipe swipe = Swipe(
      _defaultAnimation,
      begin: position._offset,
      end: _directionToTarget(direction),
    );
    _activityHistory.add(swipe);
    widget.onSwipe?.call(position._baseIndex + 1, direction);
    await _startActivity(swipe);
  }

  Future<void> _onUnSwipe() async {
    if (_activityHistory.isEmpty) {
      // There is no history to swipe from.
      return widget.unswipe?.call(false);
    }
    widget.unswipe?.call(true);
    final Swipe swipeToUndo = _activityHistory.removeLast();
    await _startActivity(Unswipe(
      _defaultAnimation,
      begin: _directionToTarget(swipeToUndo.direction),
    ));
  }

  // Moves the card back to starting position when a drag finished without
  // having reached the threshold.
  void _onSwipeCancelled(BuildContext context) {
    widget.onSwipeCancelled?.call();
    _startActivity(CancelSwipe(
      _defaultAnimation,
      begin: position._offset,
    ));
  }

  Future<void> _startActivity(SwiperActivity newActivity) async {
    _swipeActivity = newActivity;
    newActivity.animation.addListener(() {
      position.offset = newActivity.currentOffset;
      setState(() {});
    });
    final Future<void> activityFuture = newActivity.animation.forward()
      ..whenCompleteOrCancel(() {
        position._rotationPosition = null;
        // Close the activity after it finishes.
        newActivity.animation.dispose();
        if (_swipeActivity == newActivity) {
          // Only null out the activity if it is still the active swipe.
          _swipeActivity = null;
        }
        switch (newActivity) {
          case Swipe():
            position._baseIndex++;
            break;
          case Unswipe():
            position._baseIndex--;
            break;
          case CancelSwipe():
          case DrivenActivity():
            break;
        }
        if (newActivity is! DrivenActivity) {
          position._offset = Offset.zero;
        }
      });
    await activityFuture;
    setState(() {});
  }

  Future<void> _animateTo(
    Offset target, {
    required Duration duration,
    required Curve curve,
  }) async {
    final DrivenActivity newActivity = DrivenActivity(
      AnimationController(
        vsync: this,
        duration: duration,
      ),
      curve: curve,
      begin: position.offset,
      end: target,
    );
    await _startActivity(newActivity);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Attach the controller after the frame because `_attach` uses `position`
      // which isn't valid until after `initState` has finished.
      widget.controller?._attach(this);
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?._detach();
    _swipeActivity?.animation.dispose();
  }

  @override
  void didUpdateWidget(covariant AppinioSwiper oldWidget) {
    if (oldWidget.cardCount != widget.cardCount ||
        oldWidget.threshold != widget.threshold ||
        oldWidget.maxAngle != widget.maxAngle ||
        oldWidget.invertAngleOnBottomDrag != widget.invertAngleOnBottomDrag ||
        oldWidget.loop != widget.loop) {
      position._updateFromWidgetState(widget);
      widget.controller?._attach(this);
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(this);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    position._cardSize = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Use the clamp to ensure we don't go past 1.
    final double maxProgressToThreshold = max(
      position.offsetRelativeToSize.dx.abs(),
      position.offsetRelativeToSize.dy.abs(),
    ).clamp(0, 1);
    // If we're unswiping we need to apply the foreground transformations to the
    // incoming card item instead of the current index.
    final int foregroundIndex = _swipeActivity is Unswipe
        // Add the card count and mod it back out to handle the case where
        // loop is enabled and we're undoing the first card in the list.
        ? (position.index - 1 + widget.cardCount) % widget.cardCount
        : position.index;
    final int backgroundIndex = (foregroundIndex + 1) % widget.cardCount;
    final int effectiveBackgroundCardCount =
        _effectiveBackgroundCardCount(backgroundIndex);
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        if (effectiveBackgroundCardCount > 0)
          _BackgroundCards(
            position: position,
            indices: List.generate(
              effectiveBackgroundCardCount,
              (index) => (foregroundIndex + 1) % widget.cardCount,
            ),
            builder: widget.cardsBuilder,
            scaleIncrement: _effectiveScaleIncrement,
            offsetIncrement: _effectiveOffset,
            initialEffectFactor: 1 - maxProgressToThreshold,
            fadeLastItem:
                effectiveBackgroundCardCount > widget.backgroundCardCount,
          ),
        if (foregroundIndex < widget.cardCount)
          Transform.translate(
            offset: position.offset,
            child: GestureDetector(
              child: Transform.rotate(
                angle: position.angleRadians,
                alignment:
                    position._rotationAlignment ?? Alignment.bottomCenter,
                child: Container(
                  child: widget.cardsBuilder(context, foregroundIndex),
                ),
              ),
              onTap: () {
                if (widget.isDisabled) {
                  widget.onTapDisabled?.call();
                }
              },
              onPanStart: (tapInfo) {
                if (widget.isDisabled) {
                  return;
                }
                position._rotationPosition = tapInfo.localPosition;
              },
              onPanUpdate: (tapInfo) {
                if (widget.isDisabled) {
                  return;
                }
                setState(() {
                  final swipeOption = widget.swipeOptions;

                  final Offset tapDelta = tapInfo.delta;
                  double dx = 0;
                  double dy = 0;
                  if (swipeOption.up && tapDelta.dy < 0) {
                    dy = tapDelta.dy;
                  } else if (swipeOption.down && tapInfo.delta.dy > 0) {
                    dy = tapDelta.dy;
                  }
                  if (swipeOption.left && tapDelta.dx < 0) {
                    dx = tapDelta.dx;
                  } else if (swipeOption.right && tapInfo.delta.dx > 0) {
                    dx = tapDelta.dx;
                  }
                  position.offset += Offset(dx, dy);
                });
                _onSwiping();
              },
              onPanEnd: (tapInfo) async {
                if (!widget.isDisabled) {
                  return _onPanEnd();
                }
              },
            ),
          ),
      ],
    );
  }

  int _effectiveBackgroundCardCount(int index) {
    if (widget.cardCount == 0) {
      return 0;
    }
    // Use one extra card so cards entering the stack can fade in smoothly.
    final int effectiveCardCount = widget.backgroundCardCount + 1;
    if (widget.loop) {
      return effectiveCardCount;
    }
    final int remaining = widget.cardCount - position.index - 1;
    return (_swipeActivity is Unswipe ? remaining + 1 : remaining)
        .clamp(0, effectiveCardCount);
  }

  Future<void> _onSwiping() async {
    widget.onCardPositionChanged?.call(
      position.offset.toAxisDirection(),
      position.offset,
    );
  }

  Offset _directionToTarget(AxisDirection direction) {
    final Size size = MediaQuery.sizeOf(context);
    return switch (direction) {
      AxisDirection.up => Offset(0, -size.height),
      AxisDirection.down => Offset(0, size.height),
      AxisDirection.left => Offset(-size.width, 0),
      AxisDirection.right => Offset(size.width, 0),
    };
  }

  Future<void> _onPanEnd() async {
    // TODO: Use a ballistic simulation to determine if the swipe should be
    // triggered or not.
    // See the snapping behavior from `DraggableScrollableSheet`.
    if (position.offsetRelativeToThreshold.dx.abs() < 1 &&
        position.offsetRelativeToThreshold.dy.abs() < 1) {
      return _onSwipeCancelled(context);
    }
    await _onSwipe(position.offset.toAxisDirection());
  }

  Future<void> _onSwipeDefault() async {
    return _onSwipe(widget.defaultDirection);
  }
}

class _BackgroundCards extends StatelessWidget {
  const _BackgroundCards({
    required this.position,
    required this.indices,
    required this.builder,
    required this.scaleIncrement,
    required this.offsetIncrement,
    required this.initialEffectFactor,
    required this.fadeLastItem,
  });

  final SwiperPosition position;

  // The indices in the original card stack. This is a list instead of a start
  // and count because it may be non-contiguous if `loop` is true.
  final List<int> indices;
  final IndexedWidgetBuilder builder;
  final double scaleIncrement;
  final Offset offsetIncrement;
  final double initialEffectFactor;
  final bool fadeLastItem;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: position,
      builder: (context, child) {
        return Stack(
          children: indices
              // Convert to a map so we can get the position of the index within the
              // list of indices.
              .asMap()
              .map(
                (j, index) {
                  final double effectFactor = initialEffectFactor + j;
                  final Offset offset = offsetIncrement * effectFactor;
                  // The cards scale down by a fixed amount relative to the original
                  // size with each step so we need to subtract by the scale
                  // increment rather than multiply by the scale factor.
                  final double scale = 1 - (effectFactor * scaleIncrement);
                  if (scale <= 0) {
                    // Don't render cards if they're too small to be visible.
                    return MapEntry(j, null);
                  }
                  return MapEntry(
                    j,
                    Opacity(
                      opacity: fadeLastItem && j == indices.length - 1
                          ? position.progress
                          : 1,
                      child: Transform.translate(
                        offset: offset,
                        child: Transform.scale(
                          scale: scale,
                          child: builder(context, index),
                        ),
                      ),
                    ),
                  );
                },
              )
              .values
              .nonNulls
              .toList()
              // We need to reverse the list to get the cards to stack in descending
              // order.
              .reversed
              .toList(),
        );
      },
    );
  }
}

/// A controller used to control an [AppinioSwiper],
///
/// The controller notifies listeners when a swipe starts and for each tick of a
/// swipe animation.
class AppinioSwiperController extends ChangeNotifier {
  _AppinioSwiperState? _attachedSwiper;

  /// The current activity of the swiper.
  ///
  /// This is non null when:
  /// 1. The user has finished their drag while manually swiping.
  /// 2. A programmatic swipe is triggered from this controller.
  SwiperActivity? get swipeActivity {
    return _attachedSwiper?._swipeActivity;
  }

  /// The position of the swiper.
  SwiperPosition? get position {
    return _attachedSwiper?.position;
  }

  /// The current position of the card, as a result of a user drag and/or a
  /// swipe animation.
  ///
  /// This is 0 when there is no active swipe. It increments up to 1 during an
  /// active swipe and then resets to 0 when the swipe is complete.
  Offset get swipeProgress {
    _assertIsAttached();
    return position!.offsetRelativeToSize;
  }

  /// The index of the card currently on the top.
  ///
  /// This cycles to the next card only after the previous card has fully
  /// animated off the screen.
  int get cardIndex {
    _assertIsAttached();
    return position!.index;
  }

  /// Swipe the card in the default direction.
  ///
  /// The default direction is set by the attached [AppinioSwiper] widget.
  Future<void> swipeDefault() async {
    _assertIsAttached();
    await _attachedSwiper!._onSwipeDefault();
    notifyListeners();
  }

  /// Swipe the card to the left side.
  Future<void> swipeLeft() async {
    _assertIsAttached();
    await _attachedSwiper!._onSwipe(AxisDirection.left);
    notifyListeners();
  }

  /// Swipe the card to the right side.
  Future<void> swipeRight() async {
    _assertIsAttached();
    // ignore: unawaited_futures
    _attachedSwiper!._onSwipe(AxisDirection.right);
    notifyListeners();
  }

  /// Unswipe the card.
  Future<void> unswipe() async {
    _assertIsAttached();
    await _attachedSwiper!._onUnSwipe();
    notifyListeners();
  }

  /// Swipe the card to the top.
  Future<void> swipeUp() async {
    _assertIsAttached();
    await _attachedSwiper!._onSwipe(AxisDirection.up);
    notifyListeners();
  }

  /// Swipe the card to the bottom.
  Future<void> swipeDown() async {
    _assertIsAttached();
    await _attachedSwiper!._onSwipe(AxisDirection.down);
    notifyListeners();
  }

  /// Animate the card at the top of the stack to the specified offset.
  ///
  /// The card will not reset or snap at the end of the animation-it is up to
  /// the caller to animate the card back to the center.
  Future<void> animateTo(
    Offset target, {
    required Duration duration,
    required Curve curve,
  }) async {
    _assertIsAttached();
    await _attachedSwiper!._animateTo(
      target,
      duration: duration,
      curve: curve,
    );
  }

  void _attach(_AppinioSwiperState swiper) {
    assert(
      _attachedSwiper == null,
      'Controller can only be attached to one swiper widget at a time.',
    );
    _attachedSwiper = swiper;
    swiper.position.addListener(notifyListeners);
  }

  void _detach() {
    _attachedSwiper?.position.removeListener(notifyListeners);
    _attachedSwiper = null;
  }

  void _assertIsAttached() {
    assert(_attachedSwiper != null, 'Controller must be attached.');
  }
}

/// The position of the swiper.
///
/// This includes the current card index and the offset and rotations applied to
/// the top card. You can use this position to coordinate custom animations with
/// the swiper state.
///
/// The swiper position is exposed by [AppinioSwiperController].
class SwiperPosition with ChangeNotifier {
  SwiperPosition({
    required Size cardSize,
    required int cardCount,
    required double threshold,
    required double maxAngleRadians,
    required bool invertAngleOnBottomDrag,
    required bool loop,
  })  : _cardSize = cardSize,
        _cardCount = cardCount,
        _threshold = threshold,
        _maxAngle = maxAngleRadians,
        _invertAngleOnBottomDrag = invertAngleOnBottomDrag,
        _loop = loop;

  set offset(Offset newOffset) {
    _offset = newOffset;
    notifyListeners();
  }

  Offset get offset => _offset;

  Size get cardSize => _cardSize;

  // When the user starts a pan we save the point they tapped. We then rotate
  // the card around this point as they swipe.
  // By rotating around the point of their tap we ensure that their finger
  // stays in the same local position relative to the card.
  Offset? _rotationPosition;

  Alignment? get _rotationAlignment => _rotationPosition?.toAlignment(cardSize);

  // All variables are private so that they can be updated without allowing
  // external packages to modify them.
  Offset _offset = Offset.zero;

  Size _cardSize;

  int _cardCount;

  double _threshold;

  double _maxAngle;

  bool _loop;

  bool _invertAngleOnBottomDrag;

  // This is the index before modulo-ing to account for looping.
  int _baseIndex = 0;

  int get index => _loop ? _baseIndex % _cardCount : _baseIndex;

  double get progress => max(
        offsetRelativeToSize.dx.abs(),
        offsetRelativeToSize.dy.abs(),
      );

  double get progressRelativeToThreshold {
    final Offset offset = offsetRelativeToThreshold;
    if (offset.dx.abs() > offset.dy) {
      return offset.dx;
    }
    return offset.dy;
  }

  Offset get offsetRelativeToSize => Offset(
        _offset.dx / _cardSize.width,
        _offset.dy / _cardSize.height,
      );

  Offset get offsetRelativeToThreshold => Offset(
        _offset.dx / _threshold,
        _offset.dy / _threshold,
      );

  double get angle {
    // If we allow inverting the direction and the user is dragging from the
    // bottom half of the card, angle in the opposite direction.
    final direction = _invertAngleOnBottomDrag &&
            _rotationAlignment != null &&
            _rotationAlignment!.y > 0
        ? -1
        : 1;
    return (direction * (_maxAngle / 100) * (_offset.dx / 10))
        .clamp(-_maxAngle, _maxAngle);
  }

  double get angleRadians => angle * (pi / 180);

  void _updateFromWidgetState(AppinioSwiper widget) {
    _cardCount = widget.cardCount;
    _threshold = widget.threshold;
    _maxAngle = widget.maxAngle;
    _invertAngleOnBottomDrag = widget.invertAngleOnBottomDrag;
    _loop = widget.loop;
    notifyListeners();
  }
}
