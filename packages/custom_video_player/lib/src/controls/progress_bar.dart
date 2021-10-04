import 'package:custom_video_player/src/controls/progress_bar_indicator.dart';
import 'package:custom_video_player/src/controls/seeker.dart';
import 'package:custom_video_player/src/models/custom_video_player_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:custom_video_player/src/video_values_provider.dart';

class CustomVideoPlayerProgressBar extends StatefulWidget {
  const CustomVideoPlayerProgressBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final VideoPlayerController controller;

  @override
  _VideoProgressIndicatorState createState() => _VideoProgressIndicatorState();
}

class _VideoProgressIndicatorState extends State<CustomVideoPlayerProgressBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(updateWidgetListener);
  }

  @override
  void deactivate() {
    widget.controller.removeListener(updateWidgetListener);
    super.deactivate();
  }

  void updateWidgetListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomVideoPlayerSettings settings = Provider.of<VideoValuesProvider>(
      context,
      listen: true,
    ).customVideoPlayerSettings;

    Widget progressIndicator;
    if (widget.controller.value.isInitialized) {
      final int duration = widget.controller.value.duration.inMilliseconds;
      final int position = Provider.of<VideoValuesProvider>(context)
          .videoProgress
          .inMilliseconds;

      int maxBuffering = 0;
      for (DurationRange range in widget.controller.value.buffered) {
        final int end = range.end.inMilliseconds;
        if (end > maxBuffering) {
          maxBuffering = end;
        }
      }

      progressIndicator = ClipRRect(
        borderRadius: BorderRadius.circular(settings
            .customVideoPlayerProgressBarSettings.progressBarBorderRadius),
        child: Stack(
          children: [
            CustomVideoPlayerProgressIndicator(
              progress: maxBuffering / duration,
              progressColor:
                  settings.customVideoPlayerProgressBarSettings.bufferedColor,
              backgroundColor:
                  settings.customVideoPlayerProgressBarSettings.backgroundColor,
            ),
            CustomVideoPlayerProgressIndicator(
              progress: position / duration,
              progressColor:
                  settings.customVideoPlayerProgressBarSettings.progressColor,
              backgroundColor: Colors.transparent,
            ),
          ],
        ),
      );
    } else {
      progressIndicator = LinearProgressIndicator(
        value: null,
        valueColor: AlwaysStoppedAnimation<Color>(
            settings.customVideoPlayerProgressBarSettings.progressColor),
        backgroundColor:
            settings.customVideoPlayerProgressBarSettings.backgroundColor,
      );
    }
    final Widget paddedProgressIndicator = Padding(
      padding: settings
          .customVideoPlayerProgressBarSettings.reachableProgressBarPadding,
      child: progressIndicator,
    );

    if (settings.customVideoPlayerProgressBarSettings.allowScrubbing) {
      return CustomVideoPlayerSeeker(
        child: paddedProgressIndicator,
        videoPlayerController: widget.controller,
      );
    } else {
      return paddedProgressIndicator;
    }
  }
}
