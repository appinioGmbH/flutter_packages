import 'package:appinio_video_player/src/controls/mute_button.dart';
import 'package:appinio_video_player/src/custom_video_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:appinio_video_player/src/controls/fullscreen_button.dart';
import 'package:appinio_video_player/src/controls/play_button.dart';
import 'package:appinio_video_player/src/controls/progress_bar.dart';
import 'package:flutter/cupertino.dart';

class CustomVideoPlayerControlBar extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  final Function updateVideoState;
  final Function fadeOutOnPlay;
  const CustomVideoPlayerControlBar({
    Key? key,
    required this.customVideoPlayerController,
    required this.updateVideoState,
    required this.fadeOutOnPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: customVideoPlayerController
          .customVideoPlayerSettings.controlBarPadding,
      decoration: customVideoPlayerController
          .customVideoPlayerSettings.controlBarDecoration,
      child: Row(
        children: [
          if (customVideoPlayerController
              .customVideoPlayerSettings.showMuteButton)
            CustomVideoPlayerMuteButton(
              customVideoPlayerController: customVideoPlayerController,
              fadeOutOnPlay: fadeOutOnPlay,
            ),
          if (customVideoPlayerController
              .customVideoPlayerSettings.showPlayButton)
            CustomVideoPlayerPlayPauseButton(
              customVideoPlayerController: customVideoPlayerController,
              fadeOutOnPlay: fadeOutOnPlay,
            ),
          if (customVideoPlayerController
              .customVideoPlayerSettings.showDurationPlayed)
            Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 5.0,
              ),
              child: ValueListenableBuilder<Duration>(
                valueListenable:
                    customVideoPlayerController.videoProgressNotifier,
                builder: ((context, progress, child) {
                  return Text(
                    getDurationAsString(progress),
                    style: customVideoPlayerController
                        .customVideoPlayerSettings.durationPlayedTextStyle,
                  );
                }),
              ),
            ),
          Expanded(
            child: CustomVideoPlayerProgressBar(
              customVideoPlayerController: customVideoPlayerController,
            ),
          ),
          if (customVideoPlayerController
              .customVideoPlayerSettings.showDurationRemaining)
            Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 5.0,
              ),
              child: ValueListenableBuilder<Duration>(
                valueListenable:
                    customVideoPlayerController.videoProgressNotifier,
                builder: ((context, progress, child) {
                  return Text(
                    "-" +
                        getDurationAsString(customVideoPlayerController
                                .videoPlayerController.value.duration -
                            progress),
                    style: customVideoPlayerController
                        .customVideoPlayerSettings.durationRemainingTextStyle,
                  );
                }),
              ),
            ),
          if (customVideoPlayerController
              .customVideoPlayerSettings.showFullscreenButton)
            CustomVideoPlayerFullscreenButton(
              customVideoPlayerController: customVideoPlayerController,
            )
        ],
      ),
    );
  }

  String getDurationAsString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours);
    if (int.parse(twoDigitMinutes) < 0) {
      twoDigitMinutes = "00";
    }
    if (int.parse(twoDigitSeconds) < 0) {
      twoDigitSeconds = "00";
    }
    if (int.parse(twoDigitHours) < 0) {
      twoDigitHours = "00";
    }
    if (duration > const Duration(hours: 1)) {
      return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}
