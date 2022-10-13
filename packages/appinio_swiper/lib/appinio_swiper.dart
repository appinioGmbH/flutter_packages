import 'dart:math';

import 'package:flutter/material.dart';

class AppinioSwiper extends StatefulWidget {
  /// list of widgets for the swiper
  final List<Widget?>? cards;

  /// controller to trigger unswipe action
  final AppinioSwiperController? controller;

  /// duration of every animation
  final Duration duration;

  /// padding of the swiper
  final EdgeInsetsGeometry padding;

  /// maximum angle the card reaches while swiping
  final double maxAngle;

  /// threshold from which the card is swiped away
  final int threshold;

  /// set to true if swiping should be disabled, exception: triggered from the outside
  final bool isDisabled;

  /// set to false if unswipe should be disabled
  final bool allowUnswipe;

  /// set to true if the user can unswipe as many cards as possible
  final bool unlimitedUnswipe;

  /// function that gets called with the new index and detected swipe direction when the user swiped or swipe is triggered by controller
  final Function onSwipe;

  /// function that gets called when there is no widget left to be swiped away
  final Function onEnd;

  /// function that gets triggered when the swiper is disabled
  final Function onTapDisabled;

  /// function that gets called with the boolean true when the last card gets unswiped and with the boolean false when there is no card to unswipe
  final Function unswipe;

  /// direction in which the card gets swiped when triggered by controller, default set to right
  final AppinioSwiperDirection direction;

  const AppinioSwiper({
    Key? key,
    required this.cards,
    this.controller,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
    this.duration = const Duration(milliseconds: 200),
    this.maxAngle = 30,
    this.threshold = 50,
    this.isDisabled = false,
    this.allowUnswipe = true,
    this.unlimitedUnswipe = false,
    this.onTapDisabled = emptyFunction,
    this.onSwipe = emptyFunctionIndex,
    this.onEnd = emptyFunction,
    this.unswipe = emptyFunctionBool,
    this.direction = AppinioSwiperDirection.right,
  })  : assert(maxAngle >= 0 && maxAngle <= 360),
        assert(threshold >= 1 && threshold <= 100),
        assert(direction != AppinioSwiperDirection.none),
        super(key: key);

  @override
  State createState() => _AppinioSwiperState();
}

class _AppinioSwiperState extends State<AppinioSwiper>
    with SingleTickerProviderStateMixin {
  double _left = 0;
  double _top = 0;
  double _total = 0;
  double _angle = 0;
  double _maxAngle = 0;
  double _scale = 0.9;
  double _difference = 40;

  int _swipeTyp = 0; // 1 = swipe, 2 = unswipe, 3 = goBack
  bool _tapOnTop = false; //position of starting drag point on card

  late AnimationController _animationController;
  late Animation<double> _leftAnimation;
  late Animation<double> _topAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _differenceAnimation;
  late Animation<double> _unSwipeLeftAnimation;
  late Animation<double> _unSwipeTopAnimation;

  bool _vertical = false;
  bool _horizontal = false;
  bool _isUnswiping = false;
  int _swipedDirectionVertical = 0; //-1 left, 1 right
  int _swipedDirectionHorizontal = 0; //-1 bottom, 1 top

  AppinioUnswipeCard? _lastCard;
  // ignore: prefer_final_fields
  List<AppinioUnswipeCard?> _lastCards = [];
  AppinioSwiperDirection detectedDirection = AppinioSwiperDirection.none;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      widget.controller!
        //swipe widget from the outside
        ..addListener(() {
          if (widget.controller!.state == AppinioSwiperState.swipe) {
            if (widget.cards!.isNotEmpty) {
              switch (widget.direction) {
                case AppinioSwiperDirection.right:
                  _swipeHorizontal(context);
                  break;
                case AppinioSwiperDirection.left:
                  _swipeHorizontal(context);
                  break;
                case AppinioSwiperDirection.top:
                  _swipeVertical(context);
                  break;
                case AppinioSwiperDirection.bottom:
                  _swipeVertical(context);
                  break;
                case AppinioSwiperDirection.none:
                  break;
              }
              _animationController.forward();
            }
          }
        })
        //swipe widget left from the outside
        ..addListener(() {
          if (widget.controller!.state == AppinioSwiperState.swipeLeft) {
            if (widget.cards!.isNotEmpty) {
              _left = -1;
              _swipeHorizontal(context);
              _animationController.forward();
            }
          }
        })
        //swipe widget right from the outside
        ..addListener(() {
          if (widget.controller!.state == AppinioSwiperState.swipeRight) {
            if (widget.cards!.isNotEmpty) {
              _left = widget.threshold + 1;
              _swipeHorizontal(context);
              _animationController.forward();
            }
          }
        })
        //unswipe widget from the outside
        ..addListener(() {
          if (widget.controller!.state == AppinioSwiperState.unswipe) {
            if (widget.allowUnswipe) {
              if (!_isUnswiping) {
                if (_lastCard != null || _lastCards.isNotEmpty) {
                  if (widget.unlimitedUnswipe) {
                    _unswipe(_lastCards.last!);
                  } else {
                    _unswipe(_lastCard!);
                  }
                  widget.unswipe(true);
                  _animationController.forward();
                } else {
                  widget.unswipe(false);
                }
              }
            }
          }
        });
    }

    if (widget.maxAngle > 0) {
      _maxAngle = widget.maxAngle * (pi / 180);
    }

    _animationController =
        AnimationController(duration: widget.duration, vsync: this);
    _animationController.addListener(() {
      //when value of controller changes
      if (_animationController.status == AnimationStatus.forward) {
        setState(() {
          if (_swipeTyp != 2) {
            _left = _leftAnimation.value;
            _top = _topAnimation.value;
          }
          if (_swipeTyp == 2) {
            _left = _unSwipeLeftAnimation.value;
            _top = _unSwipeTopAnimation.value;
          }
          _scale = _scaleAnimation.value;
          _difference = _differenceAnimation.value;
        });
      }
    });

    _animationController.addStatusListener((status) {
      //when status of controller changes
      if (status == AnimationStatus.completed) {
        setState(() {
          if (_swipeTyp == 1) {
            if (widget.unlimitedUnswipe) {
              _lastCards.add(
                AppinioUnswipeCard(
                  widget: widget.cards!.last!,
                  horizontal: _horizontal,
                  vertical: _vertical,
                  swipedDirectionHorizontal: _swipedDirectionHorizontal,
                  swipedDirectionVertical: _swipedDirectionVertical,
                ),
              );
            } else {
              _lastCard = AppinioUnswipeCard(
                widget: widget.cards!.last!,
                horizontal: _horizontal,
                vertical: _vertical,
                swipedDirectionHorizontal: _swipedDirectionHorizontal,
                swipedDirectionVertical: _swipedDirectionVertical,
              );
            }
            _swipedDirectionHorizontal = 0;
            _swipedDirectionVertical = 0;
            _vertical = false;
            _horizontal = false;
            widget.cards!.removeLast();

            widget.onSwipe(widget.cards!.length, detectedDirection);
            if (widget.cards!.isEmpty) widget.onEnd();
          } else if (_swipeTyp == 2) {
            if (widget.unlimitedUnswipe) {
              _lastCards.removeLast();
            } else {
              _lastCard = null;
            }
            _isUnswiping = false;
          }
          _animationController.reset();
          _left = 0;
          _top = 0;
          _total = 0;
          _angle = 0;
          _scale = 0.9;
          _difference = 40;
          _swipeTyp = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          padding: widget.padding,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    ...widget.cards!
                        .asMap()
                        .map((index, _) {
                          return MapEntry(
                            index,
                            _item(constraints, index),
                          );
                        })
                        .values
                        .toList(),
                  ]);
            },
          ),
        );
      },
    );
  }

  Widget _item(BoxConstraints constraints, int index) {
    if (index != widget.cards!.length - 1) {
      return Visibility(
        visible: widget.cards!.length - index <= 2,
        child: Positioned(
          top: _difference,
          left: 0,
          child: Container(
            color: Colors.transparent,
            child: Transform.scale(
              scale: _scale,
              child: Container(
                constraints: constraints,
                child: widget.cards![index],
              ),
            ),
          ),
        ),
      );
    }

    return Positioned(
      left: _left,
      top: _top,
      child: GestureDetector(
        child: Transform.rotate(
          angle: _angle,
          child: Container(
            constraints: constraints,
            child: widget.cards![index],
          ),
        ),
        onTap: () {
          if (widget.isDisabled) {
            widget.onTapDisabled();
          }
        },
        onPanStart: (tapInfo) {
          if (!widget.isDisabled) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            Offset position = renderBox.globalToLocal(tapInfo.globalPosition);

            if (position.dy < renderBox.size.height / 2) _tapOnTop = true;
          }
        },
        onPanUpdate: (tapInfo) {
          if (!widget.isDisabled) {
            setState(() {
              _left += tapInfo.delta.dx;
              _top += tapInfo.delta.dy;
              _total = _left + _top;
              _calculateAngle();
              _calculateScale();
              _calculateDifference();
            });
          }
        },
        onPanEnd: (tapInfo) {
          if (!widget.isDisabled) {
            _tapOnTop = false;
            _onEndAnimation();
            _animationController.forward();
          }
        },
      ),
    );
  }

  void _calculateAngle() {
    if (_angle <= _maxAngle && _angle >= -_maxAngle) {
      (_tapOnTop == true)
          ? _angle = (_maxAngle / 100) * (_left / 10)
          : _angle = (_maxAngle / 100) * (_left / 10) * -1;
    }
  }

  void _calculateScale() {
    if (_scale <= 1.0 && _scale >= 0.9) {
      _scale =
          (_total > 0) ? 0.9 + (_total / 5000) : 0.9 + -1 * (_total / 5000);
    }
  }

  void _calculateDifference() {
    if (_difference >= 0 && _difference <= _difference) {
      _difference = (_total > 0) ? 40 - (_total / 10) : 40 + (_total / 10);
    }
  }

  void _onEndAnimation() {
    if (_left < -widget.threshold || _left > widget.threshold) {
      _swipeHorizontal(context);
    } else if (_top < -widget.threshold || _top > widget.threshold) {
      _swipeVertical(context);
    } else {
      _goBack(context);
    }
  }

  //moves the card away to the left or right
  void _swipeHorizontal(BuildContext context) {
    setState(() {
      _swipeTyp = 1;
      _leftAnimation = Tween<double>(
        begin: _left,
        end: (_left == 0)
            ? (widget.direction == AppinioSwiperDirection.right)
                ? MediaQuery.of(context).size.width
                : -MediaQuery.of(context).size.width
            : (_left > widget.threshold)
                ? MediaQuery.of(context).size.width
                : -MediaQuery.of(context).size.width,
      ).animate(_animationController);
      _topAnimation = Tween<double>(
        begin: _top,
        end: _top + _top,
      ).animate(_animationController);
      _scaleAnimation = Tween<double>(
        begin: _scale,
        end: 1.0,
      ).animate(_animationController);
      _differenceAnimation = Tween<double>(
        begin: _difference,
        end: 0,
      ).animate(_animationController);
    });
    if (_left > widget.threshold ||
        _left == 0 && widget.direction == AppinioSwiperDirection.right) {
      _swipedDirectionHorizontal = 1;
      detectedDirection = AppinioSwiperDirection.right;
    } else {
      _swipedDirectionHorizontal = -1;
      detectedDirection = AppinioSwiperDirection.left;
    }
    (_top <= 0) ? _swipedDirectionVertical = 1 : _swipedDirectionVertical = -1;
    _horizontal = true;
  }

  //moves the card away to the top or bottom
  void _swipeVertical(BuildContext context) {
    setState(() {
      _swipeTyp = 1;
      _leftAnimation = Tween<double>(
        begin: _left,
        end: _left + _left,
      ).animate(_animationController);
      _topAnimation = Tween<double>(
        begin: _top,
        end: (_top == 0)
            ? (widget.direction == AppinioSwiperDirection.bottom)
                ? MediaQuery.of(context).size.height
                : -MediaQuery.of(context).size.height
            : (_top > widget.threshold)
                ? MediaQuery.of(context).size.height
                : -MediaQuery.of(context).size.height,
      ).animate(_animationController);
      _scaleAnimation = Tween<double>(
        begin: _scale,
        end: 1.0,
      ).animate(_animationController);
      _differenceAnimation = Tween<double>(
        begin: _difference,
        end: 0,
      ).animate(_animationController);
    });
    if (_top > widget.threshold ||
        _top == 0 && widget.direction == AppinioSwiperDirection.bottom) {
      _swipedDirectionVertical = -1;
      detectedDirection = AppinioSwiperDirection.bottom;
    } else {
      _swipedDirectionVertical = 1;
      detectedDirection = AppinioSwiperDirection.top;
    }
    (_left >= 0)
        ? _swipedDirectionHorizontal = 1
        : _swipedDirectionHorizontal = -1;
    _vertical = true;
  }

  //moves the card back to starting position
  void _goBack(BuildContext context) {
    setState(() {
      _swipeTyp = 3;
      _leftAnimation = Tween<double>(
        begin: _left,
        end: 0,
      ).animate(_animationController);
      _topAnimation = Tween<double>(
        begin: _top,
        end: 0,
      ).animate(_animationController);
      _scaleAnimation = Tween<double>(
        begin: _scale,
        end: 0.9,
      ).animate(_animationController);
      _differenceAnimation = Tween<double>(
        begin: _difference,
        end: 40,
      ).animate(_animationController);
    });
  }

  //unswipe the card: brings back the last card that was swiped away
  void _unswipe(AppinioUnswipeCard card) {
    _isUnswiping = true;
    widget.cards!.add(card.widget);
    _swipeTyp = 2;
    //unSwipe horizontal
    if (card.horizontal == true) {
      _unSwipeLeftAnimation = Tween<double>(
        begin: (card.swipedDirectionHorizontal == 1)
            ? MediaQuery.of(context).size.width
            : -MediaQuery.of(context).size.width,
        end: 0,
      ).animate(_animationController);
      _unSwipeTopAnimation = Tween<double>(
        begin: (card.swipedDirectionVertical == 1)
            ? -MediaQuery.of(context).size.height / 4
            : MediaQuery.of(context).size.height / 4,
        end: 0,
      ).animate(_animationController);
      _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: _scale,
      ).animate(_animationController);
      _differenceAnimation = Tween<double>(
        begin: 0,
        end: _difference,
      ).animate(_animationController);
    }
    //unSwipe vertical
    if (card.vertical == true) {
      _unSwipeLeftAnimation = Tween<double>(
        begin: (card.swipedDirectionHorizontal == 1)
            ? MediaQuery.of(context).size.width / 4
            : -MediaQuery.of(context).size.width / 4,
        end: 0,
      ).animate(_animationController);
      _unSwipeTopAnimation = Tween<double>(
        begin: (card.swipedDirectionVertical == 1)
            ? -MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height,
        end: 0,
      ).animate(_animationController);
      _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: _scale,
      ).animate(_animationController);
      _differenceAnimation = Tween<double>(
        begin: 0,
        end: _difference,
      ).animate(_animationController);
    }

    setState(() {});
  }
}

//for null safety
void emptyFunction() {}
void emptyFunctionIndex(int index, AppinioSwiperDirection direction) {}
void emptyFunctionBool(bool unswiped) {}

//to call the swipe or unswipe function from outside of the appinio swiper
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
}

class AppinioUnswipeCard {
  Widget widget;
  bool horizontal;
  bool vertical;
  int swipedDirectionHorizontal;
  int swipedDirectionVertical;

  AppinioUnswipeCard({
    required this.widget,
    required this.horizontal,
    required this.vertical,
    required this.swipedDirectionHorizontal,
    required this.swipedDirectionVertical,
  });
}

enum AppinioSwiperState { swipe, swipeLeft, swipeRight, unswipe }

enum AppinioSwiperDirection { none, left, right, top, bottom }
