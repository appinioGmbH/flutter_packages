import 'package:flutter/material.dart';

enum TimerState {
  idle,
  start,
  pause,
  resume,
  stop,
  reset,
}

class TimerCountdownController extends ValueNotifier<TimerState> {
  TimerCountdownController({
    required final Duration duration,
  })  : _duration = duration,
        super(TimerState.idle);

  final Duration _duration;
  Duration get duration => _duration;

  /// Starts the timer.
  void start() {
    value = TimerState.start;
  }

  /// Pauses the timer.
  void pause() {
    value = TimerState.pause;
  }

  /// Resumes the timer.
  void resume() {
    value = TimerState.resume;
  }

  /// Stops the timer.
  void stop() {
    value = TimerState.stop;
  }

  /// Resets the timer.
  void reset() {
    value = TimerState.reset;
  }
}
