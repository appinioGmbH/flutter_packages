import 'package:flutter/cupertino.dart';

import 'package:appinio_video_player/src/custom_video_player_controller.dart';

class CustomVideoPlayerFullscreenButton extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  final bool? isFullscreen;
  final Function updateView;
  const CustomVideoPlayerFullscreenButton({
    Key? key,
    required this.customVideoPlayerController,
    required this.updateView,
    this.isFullscreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (customVideoPlayerController.isFullscreen) {
          customVideoPlayerController.setFullscreen(false);
        } else {
          await customVideoPlayerController.setFullscreen(
            true,
          );
        }
      },
      child: customVideoPlayerController.isFullscreen
          ? customVideoPlayerController
              .customVideoPlayerSettings.exitFullscreenButton
          : customVideoPlayerController
              .customVideoPlayerSettings.enterFullscreenButton,
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
