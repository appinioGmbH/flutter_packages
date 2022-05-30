import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:appinio_video_player/src/controls/all_controls_overlay.dart';
import 'package:flutter/cupertino.dart';

class CustomVideoPlayer extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;

  const CustomVideoPlayer({
    Key? key,
    required this.customVideoPlayerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (customVideoPlayerController.videoPlayerController.value.isInitialized) {
      return AspectRatio(
        aspectRatio: customVideoPlayerController
                .customVideoPlayerSettings.customAspectRatio ??
            customVideoPlayerController.videoPlayerController.value.aspectRatio,
        child: Stack(
          children: [
            Container(
              color: CupertinoColors.black,
            ),
            Center(
              child: AspectRatio(
                aspectRatio: customVideoPlayerController
                    .videoPlayerController.value.aspectRatio,
                child: IgnorePointer(
                  child: VideoPlayer(
                    customVideoPlayerController.videoPlayerController,
                  ),
                ),
              ),
            ),
            AllControlsOverlay(
              customVideoPlayerController: customVideoPlayerController,
            )
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
