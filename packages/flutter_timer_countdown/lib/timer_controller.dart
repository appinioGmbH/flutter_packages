import 'dart:async';

import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

enum TimerState {
  created,
  started,
  paused,
  stopped,
}

///
class TimerController {   // TODO: extends ChangeNotifier
  late TimerCountdownState _widgetState;
  late DateTime _startTime;
  TimerState state = TimerState.created;

  ///
  TimerController();

  TimerController._internal(this._widgetState);

  factory TimerController.withState(TimerCountdownState state) {
    return TimerController._internal(state);
  }

  ///
  void setWidgetState(TimerCountdownState state) {
    _widgetState = state;
  }

  /// Calculate the time difference between now end the given [endTime] and initialize all UI timer values.
  ///
  /// Then create a periodic `Timer` which updates all fields every second depending on the time difference which is getting smaller.
  /// When this difference reached `Duration.zero` the `Timer` is stopped and the [onEnd] callback is invoked.
  void start() {
    state = TimerState.started;
    _startTime = DateTime.now();

    _onTick(); // Initial call
    _widgetState.timer = Timer.periodic(
        Duration(seconds: 1), _onTick); // Update timer asynchronously
  }

  void _onTick([Timer? timer]) {
    _widgetState.difference = getDifference();

    if (_widgetState.difference <= Duration.zero) {
      timer?.cancel();
      if (_widgetState.widget.onEnd != null) {
        _widgetState.widget.onEnd!();
      }
      return;
    }

    _widgetState.updateCountdown();
  }

  Duration getDifference() {
    DateTime now = DateTime.now();

    if (_widgetState.widget.isReverse) {
      return now.difference(_startTime);
    } else {
      return _widgetState.widget.endTime.isBefore(now)
          ? Duration.zero
          : _widgetState.widget.endTime.difference(now);
    }
  }

  void pause() {
    if (state == TimerState.started) {
      state = TimerState.paused;
    }
    print("TimerState: $state");

    // To be implemented

    _widgetState.updateCountdown();
  }

  void resume() {
    if (state == TimerState.paused) {
      state = TimerState.started;
    }
    print("TimerState: $state");

    // To be implemented

    _widgetState.updateCountdown();
  }

  void stop() {
    if (state != TimerState.stopped) {
      state = TimerState.stopped;
    }
    print("TimerState: $state");

    // To be implemented

    _widgetState.updateCountdown();
  }
}
