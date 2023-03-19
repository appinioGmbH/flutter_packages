import 'dart:math';

import 'package:appinio_swiper/types.dart';
import 'package:flutter/material.dart';

import 'controllers.dart';
import 'enums.dart';

export 'enums.dart';
export 'controllers.dart';
export 'types.dart';

class AppinioSwiper extends StatefulWidget {
  /// widget builder for creating cards
  final CardsBuilder cardsBuilder;

  ///cards count
  final int cardsCount;

  /// controller to trigger unswipe action
  final AppinioSwiperController? controller;

  /// duration of every animation
  final Duration duration;

  /// padding of the swiper
  final EdgeInsetsGeometry padding;

  /// maximum angle the card reaches while swiping
  final double maxAngle;

  /// set to true if verticalSwipe should be disabled, exception: triggered from the outside
  final AppinioSwipeOptions swipeOptions;

  /// threshold from which the card is swiped away
  final int threshold;

  /// set to true if swiping should be disabled, exception: triggered from the outside
  final bool isDisabled;

  /// set to false if unswipe should be disabled
  final bool allowUnswipe;

  /// set to true if you want to loop the items
  final bool loop;

  /// set to true if the user can unswipe as many cards as possible
  final bool unlimitedUnswipe;

  /// function that gets called with the new index and detected swipe direction when the user swiped or swipe is triggered by controller
  final OnSwipe? onSwipe;

  /// function that gets called when there is no widget left to be swiped away
  final VoidCallback? onEnd;

  /// function that gets triggered when the swiper is disabled
  final VoidCallback? onTapDisabled;

  /// function that gets called with the boolean true when the last card gets unswiped and with the boolean false when there is no card to unswipe
  final OnUnSwipe? unswipe;

  /// direction in which the card gets swiped when triggered by controller, default set to right
  final AppinioSwiperDirection direction;

  const AppinioSwiper({
    Key? key,
    required this.cardsBuilder,
    required this.cardsCount,
    this.controller,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
    this.duration = const Duration(milliseconds: 200),
    this.maxAngle = 30,
    this.threshold = 50,
    this.isDisabled = false,
    this.loop = false,
    this.swipeOptions = AppinioSwipeOptions.allDirections,
    this.allowUnswipe = true,
    this.unlimitedUnswipe = false,
    this.onTapDisabled,
    this.onSwipe,
    this.onEnd,
    this.unswipe,
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
  int currentIndex = 0;

  int _swipeType = 0; // 1 = swipe, 2 = unswipe, 3 = goBack
  bool _tapOnTop = false; //position of starting drag point on card

  late AnimationController _animationController;
  late Animation<double> _leftAnimation;
  late Animation<double> _topAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _differenceAnimation;
  late Animation<double> _unSwipeLeftAnimation;
  late Animation<double> _unSwipeTopAnimation;
  final Map<int, AppinioSwiperDirection> _swiperMemo =
      {}; //keep track of the swiped items to unswipe from the same direction

  bool _unSwiped =
      false; // set this to true when user swipe the card and false when they unswipe to make sure they unswipe only once

  bool _horizontal = false;
  bool _isUnswiping = false;
  int _swipedDirectionVertical = 0; //-1 left, 1 right
  int _swipedDirectionHorizontal = 0; //-1 bottom, 1 top

  AppinioSwiperDirection detectedDirection = AppinioSwiperDirection.none;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      widget.controller!
        //swipe widget from the outside
        ..addListener(() {
          if (widget.controller!.state == AppinioSwiperState.swipe) {
            if (currentIndex < widget.cardsCount) {
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
            if (currentIndex < widget.cardsCount) {
              _left = -1;
              _swipeHorizontal(context);
              _animationController.forward();
            }
          }
        })
        //swipe widget right from the outside
        ..addListener(() {
          if (widget.controller!.state == AppinioSwiperState.swipeRight) {
            if (currentIndex < widget.cardsCount) {
              _left = widget.threshold + 1;
              _swipeHorizontal(context);
              _animationController.forward();
            }
          }
        })
        //swipe widget up from the outside
        ..addListener(() {
          if (widget.controller!.state == AppinioSwiperState.swipeUp) {
            if (currentIndex < widget.cardsCount) {
              _top = -1;
              _swipeVertical(context);
              _animationController.forward();
            }
          }
        })
        //swipe widget down from the outside
        ..addListener(() {
          if (widget.controller!.state == AppinioSwiperState.swipeDown) {
            if (currentIndex < widget.cardsCount) {
              _top = widget.threshold + 1;
              _swipeVertical(context);
              _animationController.forward();
            }
          }
        })
        //unswipe widget from the outside
        ..addListener(() {
          if (!widget.unlimitedUnswipe && _unSwiped) return;
          if (widget.controller!.state == AppinioSwiperState.unswipe) {
            if (widget.allowUnswipe) {
              if (!_isUnswiping) {
                if (currentIndex > 0) {
                  _unswipe();
                  widget.unswipe?.call(true);
                  _animationController.forward();
                } else {
                  widget.unswipe?.call(false);
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
          if (_swipeType != 2) {
            _left = _leftAnimation.value;
            _top = _topAnimation.value;
          }
          if (_swipeType == 2) {
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
          if (_swipeType == 1) {
            _swiperMemo[currentIndex] = _horizontal
                ? (_swipedDirectionHorizontal == 1
                    ? AppinioSwiperDirection.right
                    : AppinioSwiperDirection.left)
                : (_swipedDirectionVertical == 1
                    ? AppinioSwiperDirection.top
                    : AppinioSwiperDirection.bottom);
            _swipedDirectionHorizontal = 0;
            _swipedDirectionVertical = 0;
            _horizontal = false;
            if (widget.loop) {
              if (currentIndex < widget.cardsCount - 1) {
                currentIndex++;
              } else {
                currentIndex = 0;
              }
            } else {
              currentIndex++;
            }
            widget.onSwipe?.call(currentIndex, detectedDirection);
            if (currentIndex == widget.cardsCount) {
              widget.onEnd?.call();
            }
          } else if (_swipeType == 2) {
            _isUnswiping = false;
          }
          _animationController.reset();
          _left = 0;
          _top = 0;
          _total = 0;
          _angle = 0;
          _scale = 0.9;
          _difference = 40;
          _swipeType = 0;
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
                    if (widget.loop || currentIndex < widget.cardsCount - 1)
                      _backgroundItem(constraints),
                    if (currentIndex < widget.cardsCount)
                      _foregroundItem(constraints)
                  ]);
            },
          ),
        );
      },
    );
  }

  Widget _backgroundItem(BoxConstraints constraints) {
    return Positioned(
      top: _difference,
      left: 0,
      child: Container(
        color: Colors.transparent,
        child: Transform.scale(
          scale: _scale,
          child: Container(
            constraints: constraints,
            child: widget.cardsBuilder(
                context, (currentIndex + 1) % widget.cardsCount),
          ),
        ),
      ),
    );
  }

  Widget _foregroundItem(BoxConstraints constraints) {
    return Positioned(
      left: _left,
      top: _top,
      child: GestureDetector(
        child: Transform.rotate(
          angle: _angle,
          child: Container(
            constraints: constraints,
            child: widget.cardsBuilder(context, currentIndex),
          ),
        ),
        onTap: () {
          if (widget.isDisabled) {
            widget.onTapDisabled?.call();
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
              final swipeOption = widget.swipeOptions;
              switch (swipeOption) {
                case AppinioSwipeOptions.allDirections:
                  _left += tapInfo.delta.dx;
                  _top += tapInfo.delta.dy;
                  break;
                case AppinioSwipeOptions.horizontal:
                  _left += tapInfo.delta.dx;
                  break;
                case AppinioSwipeOptions.vertical:
                  _top += tapInfo.delta.dy;
                  break;
              }
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
    _unSwiped = false;
    setState(() {
      _swipeType = 1;
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
    _unSwiped = false;
    setState(() {
      _swipeType = 1;
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
  }

  //moves the card back to starting position
  void _goBack(BuildContext context) {
    setState(() {
      _swipeType = 3;
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
  void _unswipe() {
    _unSwiped = true;
    _isUnswiping = true;
    if (widget.loop) {
      if (currentIndex == 0) {
        currentIndex = widget.cardsCount - 1;
      } else {
        currentIndex--;
      }
    } else {
      if (currentIndex > 0) {
        currentIndex--;
      }
    }
    _swipeType = 2;
    //unSwipe horizontal
    if (_swiperMemo[currentIndex] == AppinioSwiperDirection.right ||
        _swiperMemo[currentIndex] == AppinioSwiperDirection.left) {
      _unSwipeLeftAnimation = Tween<double>(
        begin: (_swiperMemo[currentIndex] == AppinioSwiperDirection.right)
            ? MediaQuery.of(context).size.width
            : -MediaQuery.of(context).size.width,
        end: 0,
      ).animate(_animationController);
      _unSwipeTopAnimation = Tween<double>(
        begin: (_swiperMemo[currentIndex] == AppinioSwiperDirection.top)
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
    if (_swiperMemo[currentIndex] == AppinioSwiperDirection.top ||
        _swiperMemo[currentIndex] == AppinioSwiperDirection.bottom) {
      _unSwipeLeftAnimation = Tween<double>(
        begin: (_swiperMemo[currentIndex] == AppinioSwiperDirection.right)
            ? MediaQuery.of(context).size.width / 4
            : -MediaQuery.of(context).size.width / 4,
        end: 0,
      ).animate(_animationController);
      _unSwipeTopAnimation = Tween<double>(
        begin: (_swiperMemo[currentIndex] == AppinioSwiperDirection.top)
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
