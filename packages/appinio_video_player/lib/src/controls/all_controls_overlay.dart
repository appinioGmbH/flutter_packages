import 'package:appinio_video_player/src/custom_video_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:appinio_video_player/src/controls/control_bar.dart';
import 'package:appinio_video_player/src/controls/playback_speed_button.dart';
import 'package:appinio_video_player/src/controls/video_source_button.dart';

class AllControlsOverlay extends StatefulWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  final Function updateVideoState;
  const AllControlsOverlay({
    Key? key,
    required this.customVideoPlayerController,
    required this.updateVideoState,
  }) : super(key: key);

  @override
  State<AllControlsOverlay> createState() => _AllControlsOverlayState();
}

class _AllControlsOverlayState extends State<AllControlsOverlay> {
  bool _controlsVisible = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _toggleControlsVisibility(context),
      child: Container(
        padding: widget.customVideoPlayerController.customVideoPlayerSettings
            .controlsPadding,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VideoSourceButton(
                  customVideoPlayerController:
                      widget.customVideoPlayerController,
                  updateVideoState: widget.updateVideoState,
                ),
                if (widget.customVideoPlayerController.customVideoPlayerSettings
                    .playbackSpeedButtonAvailable)
                  PlaybackSpeedButton(
                    customVideoPlayerController:
                        widget.customVideoPlayerController,
                    visible: _controlsVisible,
                  ),
              ],
            ),
            if (widget.customVideoPlayerController.customVideoPlayerSettings
                .controlBarAvailable)
              CustomVideoPlayerControlBar(
                visible: _controlsVisible,
                customVideoPlayerController: widget.customVideoPlayerController,
                updateVideoState: widget.updateVideoState,
              ),
          ],
        ),
      ),
    );
  }

  void _toggleControlsVisibility(BuildContext context) {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });
  }
}
