import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class SeekButtons extends StatefulWidget {
  final CustomVideoPlayerController customVideoPlayerController;

  const SeekButtons({Key? key, required this.customVideoPlayerController})
      : super(key: key);

  @override
  State<SeekButtons> createState() => _SeekButtonsState();
}

class _SeekButtonsState extends State<SeekButtons> {
  bool _areControlsVisible = true;

  @override
  void initState() {
    super.initState();
    _areControlsVisible =
        widget.customVideoPlayerController.areControlsVisible.value;
    widget.customVideoPlayerController.areControlsVisible.addListener(() {
      if (!mounted) return;
      setState(() {
        _areControlsVisible =
            widget.customVideoPlayerController.areControlsVisible.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      child: _areControlsVisible
          ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    color: Colors.black12,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: InkWell(
                      onTap: onSeekForward,
                      child: const Icon(
                        Icons.rotate_left_sharp,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.black12,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: InkWell(
                      onTap: onSeekBack,
                      child: const Icon(
                        Icons.rotate_right_sharp,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  void onSeekBack() async {
    Duration? currentPosition =
        await widget.customVideoPlayerController.videoPlayerController.position;
    Duration seekDuration = widget
        .customVideoPlayerController.customVideoPlayerSettings.seekDuration;
    if (currentPosition != null) {
      Duration seekResult = Duration(
          microseconds:
              currentPosition.inMicroseconds + seekDuration.inMicroseconds);
      widget.customVideoPlayerController.videoPlayerController
          .seekTo(seekResult);
    }
  }

  void onSeekForward() async {
    Duration? currentPosition =
        await widget.customVideoPlayerController.videoPlayerController.position;
    Duration seekDuration = widget
        .customVideoPlayerController.customVideoPlayerSettings.seekDuration;
    if (currentPosition != null) {
      Duration seekResult = Duration(
          microseconds:
              currentPosition.inMicroseconds - seekDuration.inMicroseconds);
      widget.customVideoPlayerController.videoPlayerController
          .seekTo(seekResult);
    }
  }
}
