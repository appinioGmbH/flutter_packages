import 'package:appinio_video_player/src/video_values_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomVideoPlayerPlayPauseButton extends StatelessWidget {
  const CustomVideoPlayerPlayPauseButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.of<VideoValuesProvider>(context)
            .videoPlayerController
            .value
            .isPlaying
        ? GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              await Provider.of<VideoValuesProvider>(context, listen: false)
                  .videoPlayerController
                  .pause();
            },
            child: Provider.of<VideoValuesProvider>(context, listen: false)
                .customVideoPlayerSettings
                .pauseButton,
          )
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              await Provider.of<VideoValuesProvider>(context, listen: false)
                  .videoPlayerController
                  .play();
            },
            child: Provider.of<VideoValuesProvider>(context, listen: false)
                .customVideoPlayerSettings
                .playButton,
          );
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
