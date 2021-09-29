import 'package:flutter/material.dart';

class CustomVideoPlayerProgressBarSettings {
  /// The [BorderRadius] of the progress bar.
  final double progressBarBorderRadius;

  /// If set to false the progress bar will not be displayed.
  final bool showProgressBar;

  /// If set to false the video cannot be skipped by sliding the finger over the progress bar.
  final bool allowScrubbing;

  /// The padding around the progress bar where it is also reachable. Can be useful to define a larger area where the users could tap the progress bar.
  final EdgeInsets reachableProgressBarPadding;

  /// The height of the progress bar.
  final double progressBarHeight;

  /// The color of the current progress of the video.
  final Color progressColor;

  /// The color of the buffered progress.
  final Color bufferedColor;

  /// The background color of the progress bar.
  final Color backgroundColor;

  const CustomVideoPlayerProgressBarSettings({
    this.showProgressBar = true,
    this.allowScrubbing = true,
    this.reachableProgressBarPadding = const EdgeInsets.all(5),
    this.progressBarHeight = 10,
    this.progressBarBorderRadius = 10,
    this.progressColor = const Color.fromRGBO(255, 255, 255, 1),
    this.bufferedColor = const Color.fromRGBO(255, 255, 255, 0.3),
    this.backgroundColor = const Color.fromRGBO(156, 156, 156, 0.5),
  });
}
