import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'page_offset_notifier.dart';

class BackgroundImage extends ConsumerWidget {
  final int id;
  final Widget background;
  final double imageVerticalOffset;
  final double speed;
  final double imageHorizontalOffset;
  final bool centerBackground;
  final PageController pageController;

  const BackgroundImage({
    super.key,
    required this.id,
    required this.speed,
    required this.background,
    required this.imageVerticalOffset,
    required this.centerBackground,
    required this.imageHorizontalOffset,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pageOffsetNotifierProvider(pageController));
    return Stack(children: [
      Positioned(
        top: imageVerticalOffset,
        left: MediaQuery.of(context).size.width * ((id - 1) * speed) -
            speed * state.offset +
            (centerBackground ? 0 : imageHorizontalOffset),
        child: centerBackground
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: background,
              )
            : background,
      ),
    ]);
  }
}
