import 'package:appinio_video_player/src/controls/fullscreen_button.dart';
import 'package:appinio_video_player/src/controls/play_button.dart';
import 'package:appinio_video_player/src/controls/progress_bar.dart';
import 'package:appinio_video_player/src/video_values_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomVideoPlayerControlBar extends StatelessWidget {
  const CustomVideoPlayerControlBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoValuesProvider _videoValuesProvider = Provider.of<VideoValuesProvider>(
      context,
    );

    return Visibility(
      visible:
          _videoValuesProvider.customVideoPlayerController.controlBarVisible,
      maintainAnimation: true,
      maintainState: true,
      child: Container(
        margin: _videoValuesProvider.customVideoPlayerSettings.controlBarMargin,
        padding:
            _videoValuesProvider.customVideoPlayerSettings.controlBarPadding,
        decoration:
            _videoValuesProvider.customVideoPlayerSettings.controlBarDecoration,
        child: Row(
          children: [
            if (_videoValuesProvider.customVideoPlayerSettings.showPlayButton)
              const CustomVideoPlayerPlayPauseButton(),
            if (_videoValuesProvider
                .customVideoPlayerSettings.showDurationPlayed)
              Padding(
                padding: const EdgeInsets.only(
                  left: 5.0,
                  right: 5.0,
                ),
                child: Text(
                  getDurationAsString(_videoValuesProvider
                      .videoPlayerController.value.position),
                  style: _videoValuesProvider
                      .customVideoPlayerSettings.durationPlayedTextStyle,
                ),
              ),
            if (_videoValuesProvider.customVideoPlayerSettings
                .customVideoPlayerProgressBarSettings.showProgressBar)
              Expanded(
                child: CustomVideoPlayerProgressBar(
                  controller:
                      Provider.of<VideoValuesProvider>(context, listen: false)
                          .videoPlayerController,
                ),
              ),
            if (_videoValuesProvider
                .customVideoPlayerSettings.showDurationRemaining)
              Padding(
                padding: const EdgeInsets.only(
                  left: 5.0,
                  right: 5.0,
                ),
                child: Text(
                  "-" +
                      getDurationAsString(_videoValuesProvider
                              .videoPlayerController.value.duration -
                          _videoValuesProvider
                              .videoPlayerController.value.position),
                  style: _videoValuesProvider
                      .customVideoPlayerSettings.durationRemainingTextStyle,
                ),
              ),
            if (_videoValuesProvider
                .customVideoPlayerSettings.showFullscreenButton)
              const CustomVideoPlayerFullscreenButton()
          ],
        ),
      ),
    );
  }

  String getDurationAsString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration > const Duration(hours: 1)) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}
