library flutter_timer_countdown;

import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_timer_countdown/timer_countdown_controller.dart';

enum CountDownTimerFormat {
  daysHoursMinutesSeconds,
  daysHoursMinutes,
  daysHours,
  daysOnly,
  hoursMinutesSeconds,
  hoursMinutes,
  hoursOnly,
  minutesSeconds,
  minutesOnly,
  secondsOnly,
}

typedef OnTickCallBack = void Function(Duration remainingTime);

class TimerCountdown extends StatefulWidget {
  /// The controller used to control the timer.
  ///
  /// Eg. to start, stop, reset the timer.
  final TimerCountdownController controller;

  /// Format for the timer coundtown, choose between different `CountDownTimerFormat`s
  final CountDownTimerFormat format;

  /// Gives you remaining time after every tick.
  final OnTickCallBack? onTick;

  /// Function to call when the timer is over.
  final VoidCallback? onEnd;

  /// Toggle time units descriptions.
  final bool enableDescriptions;

  /// `TextStyle` for the time numbers.
  final TextStyle? timeTextStyle;

  /// `TextStyle` for the colons betwenn the time numbers.
  final TextStyle? colonsTextStyle;

  /// `TextStyle` for the description
  final TextStyle? descriptionTextStyle;

  /// Days unit description.
  final String daysDescription;

  /// Hours unit description.
  final String hoursDescription;

  /// Minutes unit description.
  final String minutesDescription;

  /// Seconds unit description.
  final String secondsDescription;

  /// Defines the width between the colons and the units.
  final double spacerWidth;

  TimerCountdown({
    required this.controller,
    this.format = CountDownTimerFormat.daysHoursMinutesSeconds,
    this.enableDescriptions = true,
    this.onEnd,
    this.timeTextStyle,
    this.onTick,
    this.colonsTextStyle,
    this.descriptionTextStyle,
    this.daysDescription = "Days",
    this.hoursDescription = "Hours",
    this.minutesDescription = "Minutes",
    this.secondsDescription = "Seconds",
    this.spacerWidth = 10,
  });

  @override
  _TimerCountdownState createState() => _TimerCountdownState();
}

class _TimerCountdownState extends State<TimerCountdown> {
  Timer? timer;
  late String countdownDays;
  late String countdownHours;
  late String countdownMinutes;
  late String countdownSeconds;

  @override
  void initState() {
    super.initState();

    // initialize the UI values with the total duration
    countdownDays = _durationToStringDays(widget.controller.duration);
    countdownHours = _durationToStringHours(widget.controller.duration);
    countdownMinutes = _durationToStringMinutes(widget.controller.duration);
    countdownSeconds = _durationToStringSeconds(widget.controller.duration);

    if (widget.controller.value == TimerState.start) _startTimer();
    widget.controller.addListener(() {
      if (widget.controller.value == TimerState.start) {
        _startTimer();
      } else if (widget.controller.value == TimerState.stop) {
        _stopTimer();
      }
    });
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  /// Creates a periodic `Timer` which updates all fields every second depending on the time difference which is getting smaller.
  /// When this difference reached `Duration.zero` the `Timer` is stopped and the [onEnd] callback is invoked.
  void _startTimer() {
    final totalDuration = widget.controller.duration;

    if (totalDuration == Duration.zero) {
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    } else {
      var durationRemaining = totalDuration;
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        durationRemaining = durationRemaining - Duration(seconds: 1);
        widget.onTick?.call(durationRemaining);

        setState(() {
          countdownDays = _durationToStringDays(durationRemaining);
          countdownHours = _durationToStringHours(durationRemaining);
          countdownMinutes = _durationToStringMinutes(durationRemaining);
          countdownSeconds = _durationToStringSeconds(durationRemaining);
        });

        if (durationRemaining <= Duration.zero) {
          timer.cancel();
          if (widget.onEnd != null) {
            widget.onEnd!();
          }
        }
      });
    }
  }

  void _stopTimer() {
    timer?.cancel();
    timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return _countDownTimerFormat();
  }

  /// Builds the UI colons between the time units.
  Widget _colon() {
    return Row(
      children: [
        SizedBox(
          width: widget.spacerWidth,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ":",
              style: widget.colonsTextStyle,
            ),
            if (widget.enableDescriptions)
              SizedBox(
                height: 5,
              ),
            if (widget.enableDescriptions)
              Text(
                "",
                style: widget.descriptionTextStyle,
              ),
          ],
        ),
        SizedBox(
          width: widget.spacerWidth,
        ),
      ],
    );
  }

  /// Builds the timer days with its description.
  Widget _days(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          countdownDays,
          style: widget.timeTextStyle,
        ),
        if (widget.enableDescriptions)
          SizedBox(
            height: 5,
          ),
        if (widget.enableDescriptions)
          Text(
            widget.daysDescription,
            style: widget.descriptionTextStyle,
          ),
      ],
    );
  }

  /// Builds the timer hours with its description.
  Widget _hours(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          countdownHours,
          style: widget.timeTextStyle,
        ),
        if (widget.enableDescriptions)
          SizedBox(
            height: 5,
          ),
        if (widget.enableDescriptions)
          Text(
            widget.hoursDescription,
            style: widget.descriptionTextStyle,
          ),
      ],
    );
  }

  /// Builds the timer minutes with its description.
  Widget _minutes(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          countdownMinutes,
          style: widget.timeTextStyle,
        ),
        if (widget.enableDescriptions)
          SizedBox(
            height: 5,
          ),
        if (widget.enableDescriptions)
          Text(
            widget.minutesDescription,
            style: widget.descriptionTextStyle,
          ),
      ],
    );
  }

  /// Builds the timer seconds with its description.
  Widget _seconds(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          countdownSeconds,
          style: widget.timeTextStyle,
        ),
        if (widget.enableDescriptions)
          SizedBox(
            height: 5,
          ),
        if (widget.enableDescriptions)
          Text(
            widget.secondsDescription,
            style: widget.descriptionTextStyle,
          ),
      ],
    );
  }

  /// When the selected [CountDownTimerFormat] is leaving out the last unit, this function puts the UI value of the unit before up by one.
  ///
  /// This is done to show the currently running time unit.
  String _twoDigits(final Duration duration, int n, String unitType) {
    switch (unitType) {
      case "minutes":
        if (widget.format == CountDownTimerFormat.daysHoursMinutes ||
            widget.format == CountDownTimerFormat.hoursMinutes ||
            widget.format == CountDownTimerFormat.minutesOnly) {
          if (duration > Duration.zero) {
            n++;
          }
        }
        if (n >= 10) return "$n";
        return "0$n";
      case "hours":
        if (widget.format == CountDownTimerFormat.daysHours ||
            widget.format == CountDownTimerFormat.hoursOnly) {
          if (duration > Duration.zero) {
            n++;
          }
        }
        if (n >= 10) return "$n";
        return "0$n";
      case "days":
        if (widget.format == CountDownTimerFormat.daysOnly) {
          if (duration > Duration.zero) {
            n++;
          }
        }
        if (n >= 10) return "$n";
        return "0$n";
      default:
        if (n >= 10) return "$n";
        return "0$n";
    }
  }

  /// Convert [Duration] in days to String for UI.
  String _durationToStringDays(Duration duration) {
    return _twoDigits(
      duration,
      duration.inDays,
      "days",
    ).toString();
  }

  /// Convert [Duration] in hours to String for UI.
  String _durationToStringHours(Duration duration) {
    if (widget.format == CountDownTimerFormat.hoursMinutesSeconds ||
        widget.format == CountDownTimerFormat.hoursMinutes ||
        widget.format == CountDownTimerFormat.hoursOnly) {
      return _twoDigits(
        duration,
        duration.inHours,
        "hours",
      );
    } else
      return _twoDigits(
        duration,
        duration.inHours.remainder(24),
        "hours",
      ).toString();
  }

  /// Convert [Duration] in minutes to String for UI.
  String _durationToStringMinutes(Duration duration) {
    if (widget.format == CountDownTimerFormat.minutesSeconds ||
        widget.format == CountDownTimerFormat.minutesOnly) {
      return _twoDigits(
        duration,
        duration.inMinutes,
        "minutes",
      );
    } else
      return _twoDigits(
        duration,
        duration.inMinutes.remainder(60),
        "minutes",
      );
  }

  /// Convert [Duration] in seconds to String for UI.
  String _durationToStringSeconds(Duration duration) {
    if (widget.format == CountDownTimerFormat.secondsOnly) {
      return _twoDigits(
        duration,
        duration.inSeconds,
        "seconds",
      );
    } else
      return _twoDigits(
        duration,
        duration.inSeconds.remainder(60),
        "seconds",
      );
  }

  /// Switches the UI to be displayed based on [CountDownTimerFormat].
  Widget _countDownTimerFormat() {
    switch (widget.format) {
      case CountDownTimerFormat.daysHoursMinutesSeconds:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _days(context),
            _colon(),
            _hours(context),
            _colon(),
            _minutes(context),
            _colon(),
            _seconds(context),
          ],
        );
      case CountDownTimerFormat.daysHoursMinutes:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _days(context),
            _colon(),
            _hours(context),
            _colon(),
            _minutes(context),
          ],
        );
      case CountDownTimerFormat.daysHours:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _days(context),
            _colon(),
            _hours(context),
          ],
        );
      case CountDownTimerFormat.daysOnly:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _days(context),
          ],
        );
      case CountDownTimerFormat.hoursMinutesSeconds:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _hours(context),
            _colon(),
            _minutes(context),
            _colon(),
            _seconds(context),
          ],
        );
      case CountDownTimerFormat.hoursMinutes:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _hours(context),
            _colon(),
            _minutes(context),
          ],
        );
      case CountDownTimerFormat.hoursOnly:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _hours(context),
          ],
        );
      case CountDownTimerFormat.minutesSeconds:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _minutes(context),
            _colon(),
            _seconds(context),
          ],
        );

      case CountDownTimerFormat.minutesOnly:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _minutes(context),
          ],
        );
      case CountDownTimerFormat.secondsOnly:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _seconds(context),
          ],
        );
      default:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _days(context),
            _colon(),
            _hours(context),
            _colon(),
            _minutes(context),
            _colon(),
            _seconds(context),
          ],
        );
    }
  }
}
