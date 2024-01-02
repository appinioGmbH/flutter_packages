import 'package:appinio_video_player/src/custom_video_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:appinio_video_player/src/controls/progress_bar_indicator.dart';
import 'package:appinio_video_player/src/controls/seeker.dart';
import 'package:cached_video_player/cached_video_player.dart';

class CustomVideoPlayerProgressBar extends StatefulWidget {
  final CustomVideoPlayerController customVideoPlayerController;

  const CustomVideoPlayerProgressBar({
    Key? key,
    required this.customVideoPlayerController,
  }) : super(key: key);

  @override
  _VideoProgressIndicatorState createState() => _VideoProgressIndicatorState();
}

class _VideoProgressIndicatorState extends State<CustomVideoPlayerProgressBar> {
  @override
  void initState() {
    super.initState();
    widget.customVideoPlayerController.videoPlayerController
        .addListener(updateWidgetListener);
  }

  @override
  void deactivate() {
    widget.customVideoPlayerController.videoPlayerController
        .removeListener(updateWidgetListener);
    super.deactivate();
  }

  void updateWidgetListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customVideoPlayerController.customVideoPlayerSettings
        .customVideoPlayerProgressBarSettings.showProgressBar) {
      Widget progressIndicator;
      if (widget.customVideoPlayerController.videoPlayerController.value
          .isInitialized) {
        final int duration = widget.customVideoPlayerController
            .videoPlayerController.value.duration.inMilliseconds;

        int maxBuffering = 0;
        for (DurationRange range in widget
            .customVideoPlayerController.videoPlayerController.value.buffered) {
          final int end = range.end.inMilliseconds;
          if (end > maxBuffering) {
            maxBuffering = end;
          }
        }

        progressIndicator = ClipRRect(
          borderRadius: BorderRadius.circular(
            widget.customVideoPlayerController.customVideoPlayerSettings
                .customVideoPlayerProgressBarSettings.progressBarBorderRadius,
          ),
          child: Stack(
            children: [
              CustomVideoPlayerProgressIndicator(
                customVideoPlayerController: widget.customVideoPlayerController,
                progress: maxBuffering / duration,
                progressColor: widget
                    .customVideoPlayerController
                    .customVideoPlayerSettings
                    .customVideoPlayerProgressBarSettings
                    .bufferedColor,
                backgroundColor: widget
                    .customVideoPlayerController
                    .customVideoPlayerSettings
                    .customVideoPlayerProgressBarSettings
                    .backgroundColor,
              ),
              ValueListenableBuilder<Duration>(
                valueListenable:
                    widget.customVideoPlayerController.videoProgressNotifier,
                builder: (context, progress, child) {
                  return CustomVideoPlayerProgressIndicator(
                    customVideoPlayerController:
                        widget.customVideoPlayerController,
                    progress: progress.inMilliseconds / duration,
                    progressColor: widget
                        .customVideoPlayerController
                        .customVideoPlayerSettings
                        .customVideoPlayerProgressBarSettings
                        .progressColor,
                    backgroundColor: Colors.transparent,
                  );
                },
              ),
            ],
          ),
        );
      } else {
        progressIndicator = LinearProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.customVideoPlayerController.customVideoPlayerSettings
                .customVideoPlayerProgressBarSettings.progressColor,
          ),
          backgroundColor: widget
              .customVideoPlayerController
              .customVideoPlayerSettings
              .customVideoPlayerProgressBarSettings
              .backgroundColor,
        );
      }
      final Widget paddedProgressIndicator = Padding(
        padding: widget.customVideoPlayerController.customVideoPlayerSettings
            .customVideoPlayerProgressBarSettings.reachableProgressBarPadding,
        child: progressIndicator,
      );

      if (widget.customVideoPlayerController.customVideoPlayerSettings
          .customVideoPlayerProgressBarSettings.allowScrubbing) {
        return CustomVideoPlayerSeeker(
          child: paddedProgressIndicator,
          customvVideoPlayerController: widget.customVideoPlayerController,
        );
      } else {
        return paddedProgressIndicator;
      }
    } else {
      return const SizedBox(
        width: double.infinity,
      );
    }
  }
}
