import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';

import 'conditional_native_web_video_player_base.dart'
    if (dart.library.io) 'conditional_native_web_video_player_mobile.dart'
    if (dart.library.html) 'conditional_native_web_video_player_web.dart';

abstract class ConditionalNativeWebVideoPlayer {
  Widget getVideoWidget(
      CustomVideoPlayerWebController customVideoPlayerWebController) {
    return const SizedBox.shrink();
  }

  factory ConditionalNativeWebVideoPlayer() => getSomething();
}
