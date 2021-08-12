import 'package:flutter/material.dart';

class BackgroundController extends StatelessWidget {
  final int currentPage;
  final int totalPage;
  final Color? controllerColor;

  BackgroundController({
    required this.currentPage,
    required this.totalPage,
    required this.controllerColor,
  });

  @override
  Widget build(BuildContext context) {
    return currentPage == totalPage - 1
        ? SizedBox.shrink()
        : Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < totalPage; i++) {
      list.add(i == currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 40),
      height: 8.0,
      width: isActive ? 28.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive
            ? controllerColor ?? Colors.white
            : (controllerColor ?? Colors.white).withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
