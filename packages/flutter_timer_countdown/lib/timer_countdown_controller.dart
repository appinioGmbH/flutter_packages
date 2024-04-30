import 'package:flutter/material.dart';

enum TimerState {
  idle,
  start,
  pause,
  resume,
  stop,
}

class TimerCountdownController extends ValueNotifier<TimerState> {
  /// Handle the timer countdown functionality.
  /// Eg. start, pause, resume, stop, reset.
  ///
  /// The [duration] is the total time of the countdown.
  TimerCountdownController({
    required final Duration duration,
  })  : _duration = duration,
        super(TimerState.idle);

  final Duration _duration;
  Duration get duration => _duration;

  /// Starts the timer.
  ///
  /// Restarts the timer if it was already started.
  void start() {
    value = TimerState.start;
  }

  /// Stops the timer.
  void stop() {
    value = TimerState.stop;
  }

  /// Pauses the timer.
  void pause() {
    value = TimerState.pause;
  }

  /// Resumes the timer.
  void resume() {
    value = TimerState.resume;
  }
}
