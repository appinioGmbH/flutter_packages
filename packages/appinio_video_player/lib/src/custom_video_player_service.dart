import 'package:appinio_video_player/src/fullscreen_video_player.dart';
import 'package:appinio_video_player/src/video_values_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayerService {
  static Future<void> enterFullscreen(
    BuildContext context,
    VideoPlayerController videoPlayerController,
    VideoValuesProvider videoValuesProvider,
  ) async {
    final TransitionRoute<void> route = PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? child) {
              return ChangeNotifierProvider<VideoValuesProvider>.value(
                value: videoValuesProvider,
                child: const FullscreenVideo(),
              );
            });
      },
    );
    setOrientationForVideo(videoPlayerController);
    Navigator.of(context).push(route);
    SystemChrome.setEnabledSystemUIMode(videoValuesProvider
        .customVideoPlayerSettings.systemUIModeInsideFullscreen);
  }

  static exitFullscreen(
    BuildContext context,
    VideoValuesProvider videoValuesProvider,
  ) async {
    await SystemChrome.setEnabledSystemUIMode(videoValuesProvider
        .customVideoPlayerSettings.systemUIModeAfterFullscreen);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Navigator.of(context).pop();
  }

  static void setOrientationForVideo(
      VideoPlayerController videoPlayerController) {
    final double videoWidth = videoPlayerController.value.size.width;
    final double videoHeight = videoPlayerController.value.size.height;
    final bool isLandscapeVideo = videoWidth > videoHeight;
    final bool isPortraitVideo = videoWidth < videoHeight;

    /// if video has more width than height set landscape orientation
    if (isLandscapeVideo) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    /// otherwise set portrait orientation
    else if (isPortraitVideo) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    /// if they are equal allow both
    else {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
  }
}
