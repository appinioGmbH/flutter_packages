import 'package:appinio_video_player/src/custom_video_player_controller.dart';
import 'package:flutter/cupertino.dart';

class CustomVideoPlayerPlayPauseButton extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  final Function fadeOutOnPlay;
  const CustomVideoPlayerPlayPauseButton({
    Key? key,
    required this.customVideoPlayerController,
    required this.fadeOutOnPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: customVideoPlayerController.isPlayingNotifier,
        builder: (context, isPlaying, _) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => _playPause(isPlaying),
            child: isPlaying
                ? customVideoPlayerController
                    .customVideoPlayerSettings.pauseButton
                : customVideoPlayerController
                    .customVideoPlayerSettings.playButton,
          );
        });
  }

  Future<void> _playPause(bool isPlaying) async {
    if (isPlaying) {
      await customVideoPlayerController.videoPlayerController.pause();
    } else {
      if (customVideoPlayerController.customVideoPlayerSettings.playOnlyOnce &&
          customVideoPlayerController.playedOnceNotifier.value) {
        return;
      } else {
        await customVideoPlayerController.videoPlayerController.play();
        fadeOutOnPlay();
      }
    }
  }
}

class CustomVideoPlayerPlayButton extends StatelessWidget {
  const CustomVideoPlayerPlayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
      child: Icon(
        CupertinoIcons.play,
        color: CupertinoColors.white,
      ),
    );
  }
}

class CustomVideoPlayerPauseButton extends StatelessWidget {
  const CustomVideoPlayerPauseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
      child: Icon(
        CupertinoIcons.pause,
        color: CupertinoColors.white,
      ),
    );
  }
}
