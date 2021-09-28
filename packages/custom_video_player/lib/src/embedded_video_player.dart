import 'package:custom_video_player/custom_video_player.dart';
import 'package:custom_video_player/src/controls/control_bar.dart';
import 'package:custom_video_player/src/video_values_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class EmbeddedVideoPlayer extends StatelessWidget {
  final double? customAspectRatio;

  const EmbeddedVideoPlayer({
    Key? key,
    this.customAspectRatio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoValuesProvider _videoValuesProvider =
        Provider.of<VideoValuesProvider>(context);

    VideoPlayerController _videoPlayerController =
        _videoValuesProvider.videoPlayerController;

    return _videoPlayerController.value.isInitialized
        ? GestureDetector(
            onTap: () => _toggleControlBarVisibility(context),
            child: AspectRatio(
              aspectRatio:
                  customAspectRatio ?? _videoPlayerController.value.aspectRatio,
              child: Stack(
                children: [
                  Container(
                    color: Colors.black,
                  ),
                  Center(
                    child: AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: IgnorePointer(
                        child: VideoPlayer(_videoPlayerController),
                      ),
                    ),
                  ),
                  if (_videoValuesProvider
                      .customVideoPlayerSettings.controlBarAvailable)
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomVideoPlayerControlBar(),
                    ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  void _toggleControlBarVisibility(BuildContext context) {
    CustomVideoPlayerController customVideoPlayerController =
        Provider.of<VideoValuesProvider>(context, listen: false)
            .customVideoPlayerController;
    if (customVideoPlayerController.controlBarVisible) {
      customVideoPlayerController.setControlBarVisibility(false);
    } else {
      customVideoPlayerController.setControlBarVisibility(true);
    }
  }
}
