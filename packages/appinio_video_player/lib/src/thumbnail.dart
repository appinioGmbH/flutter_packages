import 'package:appinio_video_player/src/custom_video_player_controller.dart';
import 'package:flutter/cupertino.dart';

class Thumbnail extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  const Thumbnail({
    Key? key,
    required this.customVideoPlayerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: customVideoPlayerController.isPlayingNotifier,
      builder: ((context, isPlaying, child) {
        if (!isPlaying) {
          if (customVideoPlayerController
              .customVideoPlayerSettings.alwaysShowThumbnailOnVideoPaused) {
            return customVideoPlayerController
                    .customVideoPlayerSettings.thumbnailWidget ??
                const SizedBox.shrink();
          } else {
            return ValueListenableBuilder<Duration>(
              valueListenable:
                  customVideoPlayerController.videoProgressNotifier,
              builder: ((context, progress, child) {
                if (progress == Duration.zero) {
                  return customVideoPlayerController
                          .customVideoPlayerSettings.thumbnailWidget ??
                      const SizedBox.shrink();
                } else {
                  return const SizedBox.shrink();
                }
              }),
            );
          }
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }
}
