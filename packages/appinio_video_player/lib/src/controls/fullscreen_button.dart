import 'package:flutter/cupertino.dart';

import 'package:appinio_video_player/appinio_video_player.dart';

class CustomVideoPlayerFullscreenButton extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  final CustomVideoPlayerSettings customVideoPlayerSettings;
  final bool? isFullscreen;
  const CustomVideoPlayerFullscreenButton({
    Key? key,
    required this.customVideoPlayerController,
    required this.customVideoPlayerSettings,
    this.isFullscreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (customVideoPlayerController.isFullscreen) {
          customVideoPlayerController.setFullscreen(false);
        } else {
          customVideoPlayerController.setFullscreen(true);
        }
      },
      child: customVideoPlayerController.isFullscreen
          ? customVideoPlayerSettings.exitFullscreenButton
          : customVideoPlayerSettings.enterFullscreenButton,
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
