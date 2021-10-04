import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:appinio_video_player/src/embedded_video_player.dart';
import 'package:appinio_video_player/src/video_values_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatelessWidget {
  /// Allows to provide an aspect ratio other than the video originally has. Remaining space will be black.
  final double? customAspectRatio;

  /// All customisation settings allowed for this [custom_video_player]. Also contains the settings for the progress bar.
  final CustomVideoPlayerSettings? customVideoPlayerSettings;

  /// Must be provided to give the [custom_video_player] a source to play from. Make sure this [VideoPlayerController] is initialized and possibly provide a loading indicator as long as its not.
  final VideoPlayerController videoPlayerController;

  /// Can be provided to make the underlying functionality of switching the fullscreen mode and the control bar visiblity accessable.
  final CustomVideoPlayerController? customVideoPlayerController;

  const CustomVideoPlayer({
    Key? key,
    this.customAspectRatio,
    this.customVideoPlayerSettings,
    required this.videoPlayerController,
    this.customVideoPlayerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VideoValuesProvider>(
      create: (context) => VideoValuesProvider(
        videoPlayerController: videoPlayerController,
        context: context,
        customVideoPlayerController:
            customVideoPlayerController ?? CustomVideoPlayerController(),
        customVideoPlayerSettings:
            customVideoPlayerSettings ?? CustomVideoPlayerSettings(),
      ),
      child: EmbeddedVideoPlayer(
        customAspectRatio: customAspectRatio,
      ),
    );
  }
}
