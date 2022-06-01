import 'package:appinio_video_player/src/custom_video_player_controller_base.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:appinio_video_player/src/models/custom_video_player_settings.dart';

class CustomVideoPlayerController extends CustomVideoPlayerControllerBase {
  CustomVideoPlayerController({
    required BuildContext context,
    required VideoPlayerController videoPlayerController,
    required CustomVideoPlayerSettings customVideoPlayerSettings,
    Map<String, VideoPlayerController>? additionalVideoSources,
  }) : super(
          context: context,
          videoPlayerController: videoPlayerController,
          customVideoPlayerSettings: customVideoPlayerSettings,
          additionalVideoSources: additionalVideoSources,
        ) {
    customVideoPlayerController = this;
  }

  /// Toggles the fullscreen view on and off.
  Future<void> setFullscreen(bool fullscreen) async {
    await setFullscreenMethod(fullscreen);
  }

  /// Disposes all created resources. Call it at your widgets dispose method when the `CustomVideoPlayer` is not used anymore.
  void dispose() {
    disposeMethod();
  }
}
