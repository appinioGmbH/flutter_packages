import 'package:flutter/material.dart';

import 'package:appinio_video_player/src/custom_video_player_controller.dart';

class PlaybackSpeedButton extends StatefulWidget {
  final bool visible;
  final CustomVideoPlayerController customVideoPlayerController;

  const PlaybackSpeedButton({
    Key? key,
    required this.visible,
    required this.customVideoPlayerController,
  }) : super(key: key);

  @override
  State<PlaybackSpeedButton> createState() => _PlaybackSpeedButtonState();
}

class _PlaybackSpeedButtonState extends State<PlaybackSpeedButton> {
  late double _currentPlaybackSpeed = widget
      .customVideoPlayerController.videoPlayerController.value.playbackSpeed;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      maintainAnimation: true,
      maintainState: true,
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () => _changePlaybackSpeed(),
          child: Container(
            padding: widget.customVideoPlayerController
                .customVideoPlayerSettings.playbackButtonPadding,
            decoration: widget.customVideoPlayerController
                .customVideoPlayerSettings.playbackSpeedButtonDecoration,
            child: Text(
              "${_currentPlaybackSpeed}x",
              style: widget.customVideoPlayerController
                  .customVideoPlayerSettings.playbackButtonTextStyle,
            ),
          ),
        ),
      ),
    );
  }

  void _changePlaybackSpeed() {
    // limiting the speed because it is not supported more by iOS
    if (_currentPlaybackSpeed < 2.0) {
      widget.customVideoPlayerController.videoPlayerController
          .setPlaybackSpeed(_currentPlaybackSpeed + 0.5);
    } else {
      widget.customVideoPlayerController.videoPlayerController
          .setPlaybackSpeed(1);
    }
    setState(() {
      _currentPlaybackSpeed = widget.customVideoPlayerController
          .videoPlayerController.value.playbackSpeed;
    });
  }
}
