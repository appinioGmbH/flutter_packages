import 'package:appinio_video_player/src/video_values_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayerFullscreenButton extends StatelessWidget {
  final VideoPlayerController? videoPlayerController;
  final bool? isFullscreen;
  final VoidCallback? onStart;
  final VoidCallback? onPlayPause;
  final VoidCallback? onEnd;
  const CustomVideoPlayerFullscreenButton({
    Key? key,
    this.videoPlayerController,
    this.isFullscreen,
    this.onStart,
    this.onPlayPause,
    this.onEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoValuesProvider videoValuesProvider =
        Provider.of<VideoValuesProvider>(context, listen: false);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (videoValuesProvider.customVideoPlayerController.isFullscreen) {
          videoValuesProvider.customVideoPlayerController.setFullscreen(false);
        } else {
          videoValuesProvider.customVideoPlayerController.setFullscreen(true);
        }
      },
      child: Provider.of<VideoValuesProvider>(context)
              .customVideoPlayerController
              .isFullscreen
          ? videoValuesProvider.customVideoPlayerSettings.exitFullscreenButton
          : videoValuesProvider.customVideoPlayerSettings.enterFullscreenButton,
    );
  }
}

class CustomVideoPlayerEnterFullscreenButton extends StatelessWidget {
  const CustomVideoPlayerEnterFullscreenButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
      child: Icon(
        CupertinoIcons.fullscreen,
        color: CupertinoColors.white,
      ),
    );
  }
}

class CustomVideoPlayerExitFullscreenButton extends StatelessWidget {
  const CustomVideoPlayerExitFullscreenButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
      child: Icon(
        CupertinoIcons.fullscreen_exit,
        color: CupertinoColors.white,
      ),
    );
  }
}
