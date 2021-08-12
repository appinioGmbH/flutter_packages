import 'package:flutter/material.dart';

class BackgroundBody extends StatelessWidget {
  final PageController controller;
  final Function function;
  final int totalPage;
  final double bodyHeight;
  final double bodyWidth;
  List<Widget> bodies;
  BackgroundBody({
    required this.controller,
    required this.function,
    required this.totalPage,
    required this.bodies,
    required this.bodyHeight,
    required this.bodyWidth,
  });

  @override
  Widget build(BuildContext context) {
    assert(bodies.length == totalPage);
    return Container(
      height: bodyHeight,
      width: bodyWidth,
      child: PageView(
        physics: ClampingScrollPhysics(),
        controller: controller,
        onPageChanged: (value) {
          function(value);
        },
        children: bodies,
      ),
    );
  }
}
