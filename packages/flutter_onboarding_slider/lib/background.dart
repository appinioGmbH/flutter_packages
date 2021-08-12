import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/background_image.dart';

class Background extends StatelessWidget {
  final Widget child;
  final int totalPage;
  final List<Widget> background;
  final double speed;
  final double imageVerticalOffset;

  Background({
    required this.imageVerticalOffset,
    required this.child,
    required this.totalPage,
    required this.background,
    required this.speed,
  });

  @override
  Widget build(BuildContext context) {
    assert(background.length == totalPage);
    return Stack(
      children: [
        for (int i = 0; i < totalPage; i++)
          BackgroundImage(
              imageVerticalOffset: imageVerticalOffset,
              id: totalPage - i,
              speed: speed,
              background: background[totalPage - i - 1]),
        child,
      ],
    );
  }
}
