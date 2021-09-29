import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/page_offset_provider.dart';
import 'package:provider/provider.dart';

class BackgroundImage extends StatelessWidget {
  final int id;
  final Widget background;
  final double imageVerticalOffset;
  final double speed;
  final double imageHorizontalOffset;

  BackgroundImage({
    required this.id,
    required this.speed,
    required this.background,
    required this.imageVerticalOffset,
    required this.imageHorizontalOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Stack(children: [
          Positioned(
            top: imageVerticalOffset,
            left: MediaQuery.of(context).size.width * ((id - 1) * speed) -
                speed * notifier.offset +
                imageHorizontalOffset,
            child: child!,
          ),
        ]);
      },
      child: Container(
        child: background,
      ),
    );
  }
}
