import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'package:example/timer_frame.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:flutter_timer_countdown/timer_countdown_controller.dart';

class TimerBasic extends StatefulWidget {
  final CountDownTimerFormat format;
  final bool inverted;

  TimerBasic({
    required this.format,
    this.inverted = false,
    Key? key,
  }) : super(key: key);

  @override
  State<TimerBasic> createState() => _TimerBasicState();
}

class _TimerBasicState extends State<TimerBasic> {
  late TimerCountdownController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TimerCountdownController(
      duration: const Duration(
        days: 15,
        hours: 20,
        minutes: 47,
        seconds: 45,
      ),
    );
    _controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TimerCountdown(
      format: widget.format,
      controller: _controller,
      onEnd: () {
        print("Timer finished");
      },
      timeTextStyle: TextStyle(
        color: (widget.inverted) ? purple : CupertinoColors.white,
        fontWeight: FontWeight.w300,
        fontSize: 40,
        fontFeatures: <FontFeature>[
          FontFeature.tabularFigures(),
        ],
      ),
      colonsTextStyle: TextStyle(
        color: (widget.inverted) ? purple : CupertinoColors.white,
        fontWeight: FontWeight.w300,
        fontSize: 40,
        fontFeatures: <FontFeature>[
          FontFeature.tabularFigures(),
        ],
      ),
      descriptionTextStyle: TextStyle(
        color: (widget.inverted) ? purple : CupertinoColors.white,
        fontSize: 10,
        fontFeatures: <FontFeature>[
          FontFeature.tabularFigures(),
        ],
      ),
      spacerWidth: 0,
      daysDescription: "days",
      hoursDescription: "hours",
      minutesDescription: "minutes",
      secondsDescription: "seconds",
    );
  }
}
