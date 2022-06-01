import 'package:appinio_video_player/src/custom_video_player_controller.dart';
import 'package:flutter/material.dart';

class PlaybackSpeedButton extends StatelessWidget {
  final bool visible;
  final CustomVideoPlayerController customVideoPlayerController;

  const PlaybackSpeedButton({
    Key? key,
    required this.visible,
    required this.customVideoPlayerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      maintainAnimation: true,
      maintainState: true,
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () => _changePlaybackSpeed(),
          child: Container(
            padding: customVideoPlayerController
                .customVideoPlayerSettings.playbackButtonPadding,
            decoration: customVideoPlayerController
                .customVideoPlayerSettings.playbackSpeedButtonDecoration,
            child: ValueListenableBuilder<double>(
              valueListenable:
                  customVideoPlayerController.playbackSpeedNotifier,
              builder: (context, playbackSpeed, _) {
                return Text(
                  "${playbackSpeed}x",
                  style: customVideoPlayerController
                      .customVideoPlayerSettings.playbackButtonTextStyle,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _changePlaybackSpeed() {
    // limiting the speed because it is not supported more by iOS
    if (customVideoPlayerController.playbackSpeedNotifier.value < 2.0) {
      customVideoPlayerController.videoPlayerController.setPlaybackSpeed(
          customVideoPlayerController.playbackSpeedNotifier.value + 0.5);
    } else {
      customVideoPlayerController.videoPlayerController.setPlaybackSpeed(1);
    }
  }
}
