import 'dart:collection';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:appinio_swiper/types.dart';
import 'package:flutter/material.dart';

import 'enums.dart';

export 'enums.dart';
export 'types.dart';

class AppinioSwiper extends StatefulWidget {
  /// The indexed widget builder that builds a card for the given index.
  final IndexedWidgetBuilder cardBuilder;

  /// The number of cards in the stack.
  final int cardCount;

  /// This callback is called when user unswipe the card
  final void Function(SwiperActivity activity)? onUnSwipe;

  /// This callback is called when user cancels the swipe before reaching threshold
  final void Function(SwiperActivity activity)? onSwipeCancelled;

  /// Allow unswipe.
  final bool allowUnSwipe;

  /// Allow unlimited unswipe.
  final bool allowUnlimitedUnSwipe;

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

  /// A callback that is called with the card's [SwiperPosition] whenever the
  /// position changes.
  final void Function(SwiperPosition position)? onCardPositionChanged;

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

  /// Callback that fires with the new swiping activity (eg a user swipes or
  /// the controller triggers a programmatic swipe).
  ///
  /// See [SwiperActivity] for a list of activities.
  final OnSwipe? onSwipeBegin;

  /// Callback that fires with a swipe activity after the activity is complete.
  ///
  /// See [SwiperActivity] for a list of activities.
  final OnSwipe? onSwipeEnd;

  /// Function that is called when the card stack runs out of cards.
  final VoidCallback? onEnd;

  /// Function that is called when a user attempts to swipe but swiping is
  /// disabled.
  final VoidCallback? onTapDisabled;

  /// The default direction in which the card gets swiped when triggered by
  /// controller.
  ///
  /// Defaults to [AxisDirection.right].
  final AxisDirection defaultDirection;

  const AppinioSwiper({
    Key? key,
    required this.cardBuilder,
    required this.cardCount,
    this.controller,
    this.duration = const Duration(milliseconds: 200),
    this.maxAngle = 15,
    this.invertAngleOnBottomDrag = true,
    this.threshold = 50,
    this.backgroundCardCount = 1,
    this.backgroundCardScale = .9,
    this.backgroundCardOffset,
    this.isDisabled = false,
    this.loop = false,
    this.swipeOptions = const SwipeOptions.all(),
    this.onTapDisabled,
    this.onSwipeBegin,
    this.onSwipeEnd,
    this.onCardPositionChanged,
    this.onEnd,
    this.defaultDirection = AxisDirection.right,
    this.allowUnSwipe = true,
    this.allowUnlimitedUnSwipe = true,
    this.onUnSwipe,
    this.onSwipeCancelled,
  })  : assert(maxAngle >= 0),
        assert(threshold > 0),
        super(key: key);

  @override
  State createState() => _AppinioSwiperState();
}

class _AppinioSwiperState extends State<AppinioSwiper>
    with TickerProviderStateMixin {
  bool _canUnSwipeOnce = false;
  static const _defaultBackgroundCardOffset = Offset(0, 40);

  double get _effectiveScaleIncrement => 1 - widget.backgroundCardScale;

  Offset get _effectiveOffset =>
      widget.backgroundCardOffset ?? _defaultBackgroundCardOffset;

  SwiperActivity? _swipeActivity;

  // The future associated with the current swipe activity.
  Future<bool>? _previousActivityFuture;

  AnimationController get _defaultAnimation => AnimationController(
        vsync: this,
        duration: widget.duration,
      );

  late final SwiperPosition _position = SwiperPosition(
    cardSize: MediaQuery.sizeOf(context),
    cardCount: widget.cardCount,
    threshold: widget.threshold,
    maxAngleRadians: widget.maxAngle,
    invertAngleOnBottomDrag: widget.invertAngleOnBottomDrag,
    loop: widget.loop,
  );

  // Keep track of the swiped items to unswipe from the same direction
  final Queue<Swipe> _activityHistory = Queue();

  bool get _canUnswipe => _activityHistory.isNotEmpty && widget.allowUnSwipe;

  Future<void> _onSwipe(AxisDirection direction) async {
    _canUnSwipeOnce = true;
    final Swipe swipe = Swipe(
      _defaultAnimation,
      begin: _position._offset,
      end: _directionToTarget(direction),
    );
    await _startActivity(swipe);
  }

  Future<void> _onUnswipe() async {
    if (!_canUnswipe) {
      return;
    }
    if (!widget.allowUnlimitedUnSwipe && !_canUnSwipeOnce) {
      return;
    }
    _canUnSwipeOnce = false;
    final Swipe swipeToUndo = _activityHistory.removeLast();
    final Unswipe unSwipe = Unswipe(
      _defaultAnimation,
      begin: _directionToTarget(swipeToUndo.direction),
    );
    await _startActivity(unSwipe);
    widget.onUnSwipe?.call(unSwipe);
  }

  // Moves the card back to starting position when a drag finished without
  // having reached the threshold.
  void _onSwipeCancelled(BuildContext context) async {
    final CancelSwipe cancelSwipe = CancelSwipe(
      _defaultAnimation,
      begin: _position._offset,
    );
    await _startActivity(cancelSwipe);
    widget.onSwipeCancelled?.call(cancelSwipe);
  }

  Future<void> _startActivity(SwiperActivity newActivity) async {
    final int previousIndex = _position.index;
    final SwiperActivity? oldActivity = _swipeActivity;
    if (oldActivity != null) {
      // Cancel the existing animation and wait for it to clean up.
      oldActivity.animation.stop();
      await _previousActivityFuture;
    }
    final int targetIndex =
        _position._baseIndexToEffectiveIndex(switch (newActivity) {
      Swipe() => _position._baseIndex + 1,
      Unswipe() => _position._baseIndex - 1,
      CancelSwipe() => _position._baseIndex,
      DrivenActivity() => _position._baseIndex,
    });
    if (targetIndex >= widget.cardCount && newActivity is Swipe) {
      // We reached the end, do not run the activity.
      if (targetIndex > widget.cardCount && !widget.loop) {
        return;
      }
      widget.onEnd?.call();
    }
    _swipeActivity = newActivity;
    if (newActivity is Swipe) {
      _activityHistory.add(newActivity);
    }
    newActivity.animation.addListener(() {
      _position.offset = newActivity.currentOffset;
      setState(() {});
    });
    widget.onSwipeBegin?.call(_position.index, targetIndex, newActivity);
    _previousActivityFuture = newActivity.animation
        .forward()
        .orCancel
        .then((_) => false)
        .onError((error, stackTrace) {
      if (error is TickerCanceled) {
        return true;
      }
      throw error!;
    }).then((wasCancelled) {
      if (disposedSwipeActivity == false) {
        newActivity.animation.dispose();
      }
      _swipeActivity = null;
      _position._rotationPosition = null;
      _position._baseIndex = targetIndex;
      _swipeActivity = null;
      if (!wasCancelled && newActivity is! DrivenActivity) {
        _position._offset = Offset.zero;
      }
      return wasCancelled;
    });
    await _previousActivityFuture;
    widget.onSwipeEnd?.call(previousIndex, targetIndex, newActivity);
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
      begin: _position.offset,
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

  bool disposedSwipeActivity = false;
  @override
  void dispose() {
    widget.controller?.dispose();
    widget.controller?._detach();
    disposedSwipeActivity = true;
    _swipeActivity?.animation.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppinioSwiper oldWidget) {
    if (oldWidget.cardCount != widget.cardCount ||
        oldWidget.threshold != widget.threshold ||
        oldWidget.maxAngle != widget.maxAngle ||
        oldWidget.invertAngleOnBottomDrag != widget.invertAngleOnBottomDrag ||
        oldWidget.loop != widget.loop) {
      _position._updateFromWidgetState(widget);
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(this);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _position._cardSize = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Use the clamp to ensure we don't go past 1.
    final double maxProgressToThreshold = max(
      _position._offsetRelativeToSize.dx.abs(),
      _position._offsetRelativeToSize.dy.abs(),
    ).clamp(0, 1);
    // If we're unswiping we need to apply the foreground transformations to the
    // incoming card item instead of the current index.
    final int foregroundIndex = _swipeActivity is Unswipe
        // Add the card count and mod it back out to handle the case where
        // loop is enabled and we're undoing the first card in the list.
        ? (_position.index + widget.cardCount - 1) % widget.cardCount
        : _position.index;
    final int backgroundIndex = _swipeActivity is Unswipe
        ? foregroundIndex
        : (foregroundIndex + 1) % widget.cardCount;
    final int effectiveBackgroundCardCount =
        _effectiveBackgroundCardCount(backgroundIndex);
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        if (effectiveBackgroundCardCount > 0)
          _BackgroundCards(
            position: _position,
            indices: List.generate(
              effectiveBackgroundCardCount,
              (index) => (foregroundIndex + 1) % widget.cardCount,
            ),
            builder: widget.cardBuilder,
            scaleIncrement: _effectiveScaleIncrement,
            offsetIncrement: _effectiveOffset,
            initialEffectFactor: 1 - maxProgressToThreshold,
            fadeLastItem:
                effectiveBackgroundCardCount > widget.backgroundCardCount,
          ),
        if (foregroundIndex < widget.cardCount)
          Transform.translate(
            offset: _position.offset,
            child: GestureDetector(
              child: Transform.rotate(
                angle: _position.angleRadians,
                alignment:
                    _position._rotationAlignment ?? Alignment.bottomCenter,
                child: Container(
                  child: widget.cardBuilder(context, foregroundIndex),
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
                _position._rotationPosition = tapInfo.localPosition;
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
                  _position.offset += Offset(dx, dy);
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
    final int remaining = widget.cardCount - _position.index - 1;
    return (_swipeActivity is Unswipe ? remaining + 1 : remaining)
        .clamp(0, effectiveCardCount);
  }

  Future<void> _onSwiping() async {
    widget.onCardPositionChanged?.call(_position);
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
    if (_position._offsetRelativeToThreshold.dx.abs() < 1 &&
        _position._offsetRelativeToThreshold.dy.abs() < 1) {
      return _onSwipeCancelled(context);
    }
    await _onSwipe(_position.offset.toAxisDirection());
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
    return _attachedSwiper?._position;
  }

  /// The history of swipes for the swiper widget currently attached to this
  /// controller.
  ///
  /// If the history is empty, un swipes will do nothing.
  Future<List<SwiperActivity>?> get activityHistory async {
    return _attachedSwiper?._activityHistory.toList(growable: false);
  }

  /// The current position of the card, as a result of a user drag and/or a
  /// swipe animation.
  ///
  /// This is 0 when there is no active swipe. It increments up to 1 during an
  /// active swipe and then resets to 0 when the swipe is complete.
  Offset? get swipeProgress {
    return position?._offsetRelativeToSize;
  }

  /// The index of the card currently on the top.
  ///
  /// This cycles to the next card only after the previous card has fully
  /// animated off the screen.
  int? get cardIndex {
    return position?.index;
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
    await _attachedSwiper!._onUnswipe();
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
    swiper._position.addListener(notifyListeners);
  }

  void _detach() {
    _attachedSwiper?._position.removeListener(notifyListeners);
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

  /// The offset of the card on the top of the stack.
  Offset get offset => _offset;

  /// The rotation angle of the card in degrees.
  ///
  /// This is 0 when [progress] is 0 and negative or positive
  /// [AppinioSwiper.maxAngle] when [progress] is 1.
  ///
  /// A negative angle indicated counterclockwise rotation, positive clockwise.
  double get angle {
    // If we allow inverting the direction and the user is dragging from the
    // bottom half of the card, angle in the opposite direction.
    final direction = _invertAngleOnBottomDrag &&
            _rotationAlignment != null &&
            _rotationAlignment!.y > 0
        ? -1
        : 1;
    return (direction * _maxAngle * (_offset.dx / _cardSize.width))
        .clamp(-_maxAngle, _maxAngle);
  }

  /// The rotation angle of the card in radians.
  ///
  /// See [angle].
  double get angleRadians => angle * (pi / 180);

  /// The current swiping progress of the top card.
  ///
  /// This is 0 when the card is centered and 1 when it is swiped offscreen and
  /// about to be dismissed.
  double get progress => max(
        _offsetRelativeToSize.dx.abs(),
        _offsetRelativeToSize.dy.abs(),
      );

  /// The current swiping progress relative to the swiping threshold.
  ///
  /// This is 0 when the card is centered and greater than 1 when it is swiped
  /// past the threshold at which a card will swipe off screen instead of
  /// returning to the center.
  double get progressRelativeToThreshold {
    final Offset offset = _offsetRelativeToThreshold;
    if (offset.dx.abs() > offset.dy) {
      return offset.dx;
    }
    return offset.dy;
  }

  /// The pixel size of the top card.
  ///
  /// This can be used to convert offsets relative to the card size.
  Size get cardSize => _cardSize;

  /// The current index of the swiper.
  ///
  /// This is updated after a [SwiperActivity] is completely finished. If
  /// [AppinioSwiper.loop] is true, this will wrap to 0 at the end of the card
  /// stack. Otherwise, it will be equal to the length of the card stack when
  /// the stack is finished.
  int get index => _baseIndexToEffectiveIndex(_baseIndex);

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

  Offset get _offsetRelativeToSize => Offset(
        _offset.dx / _cardSize.width,
        _offset.dy / _cardSize.height,
      );

  Offset get _offsetRelativeToThreshold => Offset(
        _offset.dx / _threshold,
        _offset.dy / _threshold,
      );

  void _updateFromWidgetState(AppinioSwiper widget) {
    _cardCount = widget.cardCount;
    _threshold = widget.threshold;
    _maxAngle = widget.maxAngle;
    _invertAngleOnBottomDrag = widget.invertAngleOnBottomDrag;
    _loop = widget.loop;
    notifyListeners();
  }

  int _baseIndexToEffectiveIndex(int i) {
    return _loop ? i % _cardCount : i;
  }
}
