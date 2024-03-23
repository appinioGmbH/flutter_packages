import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class VolumeControls extends StatefulWidget {
  final CustomVideoPlayerController customVideoPlayerController;

  const VolumeControls({
    Key? key,
    required this.customVideoPlayerController,
  }) : super(key: key);

  @override
  State<VolumeControls> createState() => _VolumeControlsState();
}

class _VolumeControlsState extends State<VolumeControls> {
  final GlobalKey _globalKey = GlobalKey();
  double _opacity = 0;
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onVerticalDragStart: (DragStartDetails details) {
          setState(() {
            _opacity = 1;
          });
        },
        onVerticalDragDown: (DragDownDetails details) {
          setState(() {
            _opacity = 1;
          });
        },
        onVerticalDragUpdate: onPanUpdate,
        onVerticalDragCancel: () {
          setState(() {
            _opacity = 0;
          });
        },
        onVerticalDragEnd: (DragEndDetails details) {
          setState(() {
            _opacity = 0;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 60),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _opacity,
            child: SlideController(
              widgetKey: _globalKey,
              child: Container(
                height: _progress,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onPanUpdate(DragUpdateDetails dragUpdateDetails) {
    double maxSpeedThreshold = 100.0;
    final RenderBox? _renderBoxRed =
        _globalKey.currentContext?.findRenderObject() as RenderBox;
    final double? height = _renderBoxRed?.size.height;
    final double volume =
        widget.customVideoPlayerController.videoPlayerController.value.volume;
    double factor = 0.03;
    double dx = dragUpdateDetails.primaryDelta!; // Change in x direction
    double dy = dragUpdateDetails.primaryDelta!; // Change in y direction
    double magnitude = dx * dx + dy * dy;
    double slideSpeed = sqrt(magnitude);
    double normalizedSpeed = slideSpeed / maxSpeedThreshold;
    normalizedSpeed = normalizedSpeed.clamp(0.0, 1.0);
    factor = normalizedSpeed;
    if (dragUpdateDetails.delta.dy > 0) {
      widget.customVideoPlayerController.videoPlayerController
          .setVolume(volume - factor);
      setState(() {
        _progress =
            ((volume - factor) < 0 ? 0 : (volume - factor)) * (height ?? 0);
      });
    } else if (dragUpdateDetails.delta.dy < 0) {
      widget.customVideoPlayerController.videoPlayerController
          .setVolume(volume + factor);
      setState(() {
        _progress =
            ((volume + factor) > 1 ? 1 : (volume + factor)) * (height ?? 0);
      });
    }
  }
}

class SlideController extends StatefulWidget {
  final Widget child;
  final GlobalKey widgetKey;

  const SlideController({
    Key? key,
    required this.child,
    required this.widgetKey,
  }) : super(key: key);

  @override
  State<SlideController> createState() => _SlideControllerState();
}

class _SlideControllerState extends State<SlideController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.widgetKey,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      width: 15,
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [widget.child],
      ),
    );
  }
}
