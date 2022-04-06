import 'package:appinio_video_player/src/controls/fullscreen_button.dart';
import 'package:appinio_video_player/src/controls/play_button.dart';
import 'package:appinio_video_player/src/models/custom_video_player_progress_bar_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomVideoPlayerSettings {
  /// Define a custom aspect ratio for the video.
  final double? customAspectRatio;

  /// Set to false if no control bar should be available.
  final bool controlBarAvailable;

  /// The margin of the control bar to the edges of the video player.
  final EdgeInsets controlBarMargin;

  /// The padding of the control bar from the edges to its contents.
  final EdgeInsets controlBarPadding;

  /// Define the play button appearance.
  final Widget playButton;

  /// Define the pause button appearance.
  final Widget pauseButton;

  /// Define the enter-fullscreen button appearance.
  final Widget enterFullscreenButton;

  /// Define the exit-fullscreen button appearance.
  final Widget exitFullscreenButton;

  /// The [SystemUiMode] after leaving the fullscreen mode. Defaults to [SystemUiMode.edgeToEdge].
  final SystemUiMode systemUIModeAfterFullscreen;

  /// The [SystemUiMode] when entering the fullscreen mode. Defaults to [SystemUiMode.leanBack].
  final SystemUiMode systemUIModeInsideFullscreen;

  /// The appearance of the control bar.
  final BoxDecoration controlBarDecoration;

  /// If set the video will enter the fullscreen mode on start.
  final bool enterFullscreenOnStart;

  /// If set the video will leave the fullscreen mode when its finished. Nothing happens if video wasn't in fullscreen before.
  final bool exitFullscreenOnEnd;

  /// If set to false no play/pause button will not be displayed.
  final bool showPlayButton;

  /// If set to false no enter/exit fullscrenn button will not be displayed. Default it wont be displayed in web because there fullscreen doesnt work properly
  final bool showFullscreenButton;

  /// The [TextStyle] of the played duration left from the progress bar.
  final TextStyle durationPlayedTextStyle;

  /// The [TextStyle] of the remaining duration right from the progress bar.
  final TextStyle durationRemainingTextStyle;

  /// If set to false the duration played will not be displayed.
  final bool showDurationPlayed;

  /// If set to false the duration remaining will not be displayed.
  final bool showDurationRemaining;

  /// The settings for the progress bar in the middle of the control bar.
  final CustomVideoPlayerProgressBarSettings
      customVideoPlayerProgressBarSettings;

  const CustomVideoPlayerSettings({
    this.customAspectRatio,
    this.controlBarMargin = const EdgeInsets.all(5),
    this.controlBarPadding = const EdgeInsets.all(5),
    this.playButton = const CustomVideoPlayerPlayButton(),
    this.pauseButton = const CustomVideoPlayerPauseButton(),
    this.enterFullscreenButton = const CustomVideoPlayerEnterFullscreenButton(),
    this.exitFullscreenButton = const CustomVideoPlayerExitFullscreenButton(),
    this.controlBarDecoration = const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    this.durationPlayedTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
    this.durationRemainingTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
    this.customVideoPlayerProgressBarSettings =
        const CustomVideoPlayerProgressBarSettings(),
    this.showDurationPlayed = true,
    this.showDurationRemaining = true,
    this.controlBarAvailable = true,
    this.enterFullscreenOnStart = false,
    this.exitFullscreenOnEnd = false,
    this.showPlayButton = true,
    this.showFullscreenButton = !kIsWeb,
    this.systemUIModeAfterFullscreen = SystemUiMode.edgeToEdge,
    this.systemUIModeInsideFullscreen = SystemUiMode.leanBack,
  });
}
