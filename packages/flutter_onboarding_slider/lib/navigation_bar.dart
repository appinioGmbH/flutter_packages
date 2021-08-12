import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final int currentPage;
  final Function onSkip;
  final int totalPage;
  final Function? onFinish;
  final Widget? finishButton;
  final Widget? skipTextButton;
  final Color headerBackgroundColor;

  NavigationBar({
    required this.currentPage,
    required this.onSkip,
    required this.headerBackgroundColor,
    required this.totalPage,
    this.onFinish,
    this.finishButton,
    this.skipTextButton,
  });

  @override
  Size get preferredSize => Size.fromHeight(40);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      automaticallyImplyLeading: false,
      trailing: currentPage == totalPage - 1
          ? Container(
              color: Colors.transparent,
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  onFinish == null ? () {} : onFinish!(context);
                },
                child: finishButton ?? SizedBox.shrink(),
              ),
            )
          : Container(
              color: Colors.transparent,
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  onSkip();
                },
                child: skipTextButton ?? SizedBox.shrink(),
              ),
            ),
      border: Border(
        bottom: BorderSide(color: Colors.transparent),
      ),
      backgroundColor: headerBackgroundColor,
    );
  }
}
