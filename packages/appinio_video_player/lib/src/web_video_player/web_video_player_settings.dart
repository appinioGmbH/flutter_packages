import 'package:flutter/foundation.dart';

class CustomVideoPlayerWebSettings {
  /// Key
  final Key? key;

  /// optional aspect ratio for video. must be known or found out before
  final double? aspectRatio;

  /// video url
  final String src;

  /// video startig position in seconds
  final double startAt;

  /// set autoplay
  final bool autoplay;

  /// set controls available or not
  final bool enableControls;

  /// set background color of video element. seen if video doesnt fit in the defined width & height
  final String? backgroundColor;

  /// set if video should enter fullscreen on start
  final bool enterFullscreenOnStart;

  /// It will disable PIP Mode
  final bool disablePictureInPicture;

  /// set if video should exit fullscreen on end
  final bool exitFullscreenOnEnd;

  /// set if video should be prevented from seeking. use with caution (ui is jumpin but it works)
  final bool preventSeeking;

  /// on chrome browser the more menu contains a download button which can be hidden when this is set to true
  final bool hideDownloadButton;

  /// online url to the image that should be shown when the video is not playing
  final String? thumbnailPath;

  const CustomVideoPlayerWebSettings({
    this.key,
    required this.src,
    this.aspectRatio,
    this.startAt = 0,
    this.autoplay = false,
    this.enableControls = true,
    this.backgroundColor,
    this.enterFullscreenOnStart = false,
    this.exitFullscreenOnEnd = false,
    this.preventSeeking = false,
    this.hideDownloadButton = false,
    this.disablePictureInPicture = false,
    this.thumbnailPath,
  });
}
