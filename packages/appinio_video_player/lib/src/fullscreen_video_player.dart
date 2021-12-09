import 'package:appinio_video_player/src/embedded_video_player.dart';
import 'package:flutter/material.dart';

class FullscreenVideo extends StatelessWidget {
  const FullscreenVideo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: const EmbeddedVideoPlayer(),
      ),
    );
  }
}
