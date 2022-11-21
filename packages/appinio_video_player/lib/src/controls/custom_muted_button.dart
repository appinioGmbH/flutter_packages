import 'package:appinio_video_player/src/custom_video_player_controller.dart';
import 'package:flutter/material.dart';

class CustomMutedButton extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;

  CustomMutedButton({
    Key? key,
    required this.customVideoPlayerController,
  }) : super(key: key);

  bool isMuted = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, localState) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          localState(() {
            customVideoPlayerController.setVolumeMutedUnMuted();
          });
        },
        child: customVideoPlayerController.isMuted
            ? customVideoPlayerController
                .customVideoPlayerSettings.customMutedButton
            : customVideoPlayerController
                .customVideoPlayerSettings.customUnMutedButton,
      );
    });
  }
}

class CustomVideoPlayerMutedButton extends StatelessWidget {
  const CustomVideoPlayerMutedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
      child: Icon(
        Icons.volume_off,
        color: Colors.white,
      ),
    );
  }
}

class CustomVideoPlayerUnMutedButton extends StatelessWidget {
  const CustomVideoPlayerUnMutedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
      child: Icon(
        Icons.volume_up,
        color: Colors.white,
      ),
    );
  }
}
