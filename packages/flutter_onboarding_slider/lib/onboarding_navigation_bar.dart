import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnBoardingNavigationBar extends StatelessWidget
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
  final Function? skipFunctionOverride;

  const OnBoardingNavigationBar({
    super.key,
    required this.currentPage,
    required this.onSkip,
    required this.headerBackgroundColor,
    required this.totalPage,
    this.onFinish,
    this.finishButton,
    this.skipTextButton,
    this.leading,
    this.middle,
    this.skipFunctionOverride,
  });

  @override
  Size get preferredSize => Size.fromHeight(44);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (hideNavigationBar) {
      return Container(
        width: double.infinity,
        height: 44.0,
        color: headerBackgroundColor,
      );
    }
    return CupertinoNavigationBar(
      automaticallyImplyLeading: false,
      automaticBackgroundVisibility: false,
      leading: leading,
      middle: middle,
      trailing: currentPage == totalPage - 1
          ? finishButton == null
              ? Container(
                  width: double.infinity,
                  height: 44.0,
                  color: headerBackgroundColor,
                )
              : Container(
                  color: headerBackgroundColor,
                  child: TextButton(
                    onPressed: () => onFinish?.call(),
                    child: finishButton!,
                  ),
                )
          : skipTextButton == null
              ? Container(
                  width: double.infinity,
                  height: 44.0,
                  color: headerBackgroundColor,
                )
              : Container(
                  color: headerBackgroundColor,
                  child: TextButton(
                    onPressed: () {
                      if (skipFunctionOverride == null) {
                        onSkip();
                      } else {
                        skipFunctionOverride!();
                      }
                    },
                    child: skipTextButton!,
                  ),
                ),
      border: Border(
        bottom: BorderSide(color: headerBackgroundColor),
      ),
      backgroundColor: headerBackgroundColor,
    );
  }

  bool get hideNavigationBar {
    if (currentPage == totalPage - 1) {
      return finishButton == null;
    }
    return skipTextButton == null;
  }
}
