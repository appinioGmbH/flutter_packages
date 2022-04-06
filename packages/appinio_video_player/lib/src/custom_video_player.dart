import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:appinio_video_player/src/controls/control_bar.dart';
import 'package:flutter/cupertino.dart';

class CustomVideoPlayer extends StatefulWidget {
  final CustomVideoPlayerController customVideoPlayerController;

  const CustomVideoPlayer({
    Key? key,
    required this.customVideoPlayerController,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  bool _controlBarVisible = true;

  @override
  Widget build(BuildContext context) {
    if (widget.customVideoPlayerController.videoPlayerController.value
        .isInitialized) {
      return GestureDetector(
        onTap: () => _toggleControlBarVisibility(context),
        child: AspectRatio(
          aspectRatio: widget.customVideoPlayerController
                  .customVideoPlayerSettings.customAspectRatio ??
              widget.customVideoPlayerController.videoPlayerController.value
                  .aspectRatio,
          child: Stack(
            children: [
              Container(
                color: CupertinoColors.black,
              ),
              Center(
                child: AspectRatio(
                  aspectRatio: widget.customVideoPlayerController
                      .videoPlayerController.value.aspectRatio,
                  child: IgnorePointer(
                    child: VideoPlayer(
                      widget.customVideoPlayerController.videoPlayerController,
                    ),
                  ),
                ),
              ),
              if (widget.customVideoPlayerController.customVideoPlayerSettings
                  .controlBarAvailable)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomVideoPlayerControlBar(
                    visible: _controlBarVisible,
                    customVideoPlayerSettings: widget
                        .customVideoPlayerController.customVideoPlayerSettings,
                    customVideoPlayerController:
                        widget.customVideoPlayerController,
                  ),
                ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  void _toggleControlBarVisibility(BuildContext context) {
    setState(() {
      _controlBarVisible = !_controlBarVisible;
    });
  }
}
