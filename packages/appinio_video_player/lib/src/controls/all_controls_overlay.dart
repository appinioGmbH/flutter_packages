import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:appinio_video_player/src/controls/control_bar.dart';
import 'package:appinio_video_player/src/controls/playback_speed_button.dart';
import 'package:flutter/material.dart';

class AllControlsOverlay extends StatefulWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  const AllControlsOverlay({
    Key? key,
    required this.customVideoPlayerController,
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
            if (widget.customVideoPlayerController.customVideoPlayerSettings
                .playbackSpeedButtonAvailable)
              PlaybackSpeedButton(
                customVideoPlayerController: widget.customVideoPlayerController,
                visible: _controlsVisible,
              ),
            if (widget.customVideoPlayerController.customVideoPlayerSettings
                .controlBarAvailable)
              CustomVideoPlayerControlBar(
                visible: _controlsVisible,
                customVideoPlayerController: widget.customVideoPlayerController,
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
