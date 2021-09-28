import 'package:custom_video_player/src/video_values_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayerScrubber extends StatefulWidget {
  const CustomVideoPlayerScrubber({
    Key? key,
    required this.child,
    required this.videoPlayerController,
  }) : super(key: key);

  final Widget child;
  final VideoPlayerController videoPlayerController;

  @override
  _CustomVideoPlayerScrubberState createState() =>
      _CustomVideoPlayerScrubberState();
}

class _CustomVideoPlayerScrubberState extends State<CustomVideoPlayerScrubber> {
  bool _videoPlaying = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.child,
      onHorizontalDragStart: (DragStartDetails details) {
        if (!widget.videoPlayerController.value.isInitialized) {
          return;
        }
        _videoPlaying = widget.videoPlayerController.value.isPlaying;
        if (_videoPlaying) {
          widget.videoPlayerController.pause();
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!widget.videoPlayerController.value.isInitialized) {
          return;
        }
        changeCurrentVideoPosition(details.globalPosition);
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (_videoPlaying) {
          widget.videoPlayerController.play();
        }
      },
      onTapDown: (TapDownDetails details) {
        if (!widget.videoPlayerController.value.isInitialized) {
          return;
        }
        changeCurrentVideoPosition(details.globalPosition);
      },
    );
  }

  void changeCurrentVideoPosition(Offset globalPosition) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset tapPos = box.globalToLocal(globalPosition);
    final double relative = tapPos.dx / box.size.width;
    final Duration position =
        widget.videoPlayerController.value.duration * relative;
    widget.videoPlayerController.seekTo(position);
    Provider.of<VideoValuesProvider>(context, listen: false).videoProgress =
        position;
  }
}
