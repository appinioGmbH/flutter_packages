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
  final Widget? leading;
  final Widget? middle;

  NavigationBar({
    required this.currentPage,
    required this.onSkip,
    required this.headerBackgroundColor,
    required this.totalPage,
    this.onFinish,
    this.finishButton,
    this.skipTextButton,
    this.leading,
    this.middle,
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
      leading: leading,
      middle: middle,
      trailing: currentPage == totalPage - 1
          ? finishButton == null
              ? Container(
                  color: Colors.transparent,
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => onFinish?.call(),
                    child: finishButton!,
                  ),
                )
              : SizedBox.shrink()
          : skipTextButton == null
              ? Container(
                  color: Colors.transparent,
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      onSkip();
                    },
                    child: skipTextButton!,
                  ),
                )
              : SizedBox.shrink(),
      border: Border(
        bottom: BorderSide(color: Colors.transparent),
      ),
      backgroundColor: headerBackgroundColor,
    );
  }
}
