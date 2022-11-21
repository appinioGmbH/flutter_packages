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
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
      child: StatefulBuilder(
        builder: (context, localState) {
          return GestureDetector(
            onTap: () {
              localState(() {
                isMuted = !isMuted;
                if (isMuted) {
                  customVideoPlayerController.videoPlayerController
                      .setVolume(0.0);
                } else {
                  customVideoPlayerController.videoPlayerController
                      .setVolume(1.0);
                }
              });
            },
            child: isMuted
                ? const Icon(
                    Icons.volume_off,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.volume_up,
                    color: Colors.white,
                  ),
          );
        },
      ),
    );
  }
}
