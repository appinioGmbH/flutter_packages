import 'package:appinio_video_player/src/controls/all_controls_overlay.dart';
import 'package:appinio_video_player/src/custom_video_player_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class EmbeddedVideoPlayer extends StatefulWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  final bool isFullscreen;

  const EmbeddedVideoPlayer({
    Key? key,
    required this.customVideoPlayerController,
    this.isFullscreen = false,
  }) : super(key: key);

  @override
  State<EmbeddedVideoPlayer> createState() => _EmbeddedVideoPlayerState();
}

class _EmbeddedVideoPlayerState extends State<EmbeddedVideoPlayer> {
  @override
  void initState() {
    super.initState();
    if (!widget.isFullscreen) {
      widget.customVideoPlayerController.updateViewAfterFullscreen =
          _updateVideoState;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customVideoPlayerController.videoPlayerController.value
        .isInitialized) {
      return AspectRatio(
        aspectRatio: widget.customVideoPlayerController
                .customVideoPlayerSettings.customAspectRatio ??
            widget.customVideoPlayerController.videoPlayerController.value
                .aspectRatio,
        child: Stack(
          children: [
            Container(
              color: CupertinoColors.black,
            ),
            Center(
              child: AspectRatio(
                aspectRatio: widget.customVideoPlayerController
                    .videoPlayerController.value.aspectRatio,
                child: IgnorePointer(
                  child: VideoPlayer(
                    widget.customVideoPlayerController.videoPlayerController,
                  ),
                ),
              ),
            ),
            AllControlsOverlay(
              customVideoPlayerController: widget.customVideoPlayerController,
              updateVideoState: _updateVideoState,
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  void _updateVideoState() {
    if (mounted) {
      setState(() {});
    }
  }
}
