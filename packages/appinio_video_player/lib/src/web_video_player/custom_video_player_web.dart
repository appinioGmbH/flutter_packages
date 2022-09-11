import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class CustomVideoPlayerWeb extends StatelessWidget {
  final CustomVideoPlayerWebController customVideoPlayerWebController;
  const CustomVideoPlayerWeb({
    Key? key,
    required this.customVideoPlayerWebController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConditionalNativeWebVideoPlayer()
        .getVideoWidget(customVideoPlayerWebController);
  }
}
