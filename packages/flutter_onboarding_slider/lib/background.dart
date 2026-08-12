import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'background_image.dart';

class Background extends StatelessWidget {
  final Widget child;
  final int totalPage;
  final List<Widget> background;
  final double speed;
  final double imageVerticalOffset;
  final double imageHorizontalOffset;
  final bool centerBackground;
  final PageController pageController;

  const Background({
    super.key,
    required this.imageVerticalOffset,
    required this.child,
    required this.centerBackground,
    required this.totalPage,
    required this.background,
    required this.speed,
    required this.imageHorizontalOffset,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    assert(background.length == totalPage);
    return Stack(
      children: [
        for (int i = 0; i < totalPage; i++)
          BackgroundImage(
            centerBackground: centerBackground,
            imageHorizontalOffset: imageHorizontalOffset,
            imageVerticalOffset: imageVerticalOffset,
            id: totalPage - i,
            speed: speed,
            background: background[totalPage - i - 1],
            pageController: pageController,
          ),
        child,
      ],
    );
  }
}
