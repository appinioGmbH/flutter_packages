import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class CustomVideoPlayerWebController {
  final CustomVideoPlayerWebSettings webVideoPlayerSettings;

  CustomVideoPlayerWebController({
    required this.webVideoPlayerSettings,
  });

  /// play video
  late VoidCallback play;

  /// pause video
  late VoidCallback pause;

  /// enters/leaves fullscreen
  late Function(bool) setFullscreen;

  /// seek to a specific position
  late Function(double position) seekTo;

  /// mute video
  late VoidCallback mute;

  /// unmute video
  late VoidCallback unmute;

  /// sets playback speed.
  /// 1 is normal speed.
  /// 0.5 would be 50% speed.
  /// 2 would be 200% speed.
  late Function(double speed) setPlaybackSpeed;

  late ValueNotifier<bool> isPlaying = ValueNotifier(false);
}
