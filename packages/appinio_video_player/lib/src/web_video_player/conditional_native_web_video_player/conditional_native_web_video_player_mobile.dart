import 'package:appinio_video_player/src/web_video_player/conditional_native_web_video_player/conditional_native_web_video_player.dart';
import 'package:appinio_video_player/src/web_video_player/custom_video_player_web_controller.dart';
import 'package:flutter/cupertino.dart';

class ConditionalNativeWebVideoPlayerMobile
    implements ConditionalNativeWebVideoPlayer {
  @override
  Widget getVideoWidget(
      CustomVideoPlayerWebController customVideoPlayerWebController) {
    debugPrint(
        'Tried calling web video widget on mobile. Returning empty widget. Please use the mobile video player or run on web.');
    return const SizedBox.shrink();
  }
}

ConditionalNativeWebVideoPlayer getSomething() =>
    ConditionalNativeWebVideoPlayerMobile();
