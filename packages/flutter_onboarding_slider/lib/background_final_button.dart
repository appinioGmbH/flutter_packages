import 'package:flutter/material.dart';

class BackgroundFinalButton extends StatelessWidget {
  final int currentPage;
  final PageController pageController;
  final int totalPage;
  final Function()? onPageFinish;
  final TextStyle buttonTextStyle;
  final TextStyle buttonFinishTextStyle;
  final String buttonText;
  final String buttonFinishText;
  final Color? buttonBackgroundColor;
  final double? heightButtonBottom;
  final double? widthButtonBottom;
  final IconData? iconButtonBottom;
  final IconData? iconButtonBottomFinish;
  final Color? colorIconButtonBottom;
  final double iconSize;
  BackgroundFinalButton({
    required this.currentPage,
    required this.pageController,
    required this.totalPage,
    this.onPageFinish,
    this.buttonBackgroundColor,
    required this.buttonText,
    required this.buttonFinishText,
    this.buttonTextStyle = const TextStyle(fontSize: 14),
    this.buttonFinishTextStyle = const TextStyle(fontSize: 14),
    this.heightButtonBottom,
    this.widthButtonBottom,
    this.iconSize = 20,
    this.iconButtonBottom = Icons.navigate_next,
    this.iconButtonBottomFinish = Icons.navigate_next,
    this.colorIconButtonBottom = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        width: (currentPage == totalPage - 1) ? MediaQuery.of(context).size.width - 30 : widthButtonBottom,
        height: heightButtonBottom,
        decoration: BoxDecoration(color: buttonBackgroundColor, borderRadius: BorderRadius.circular(30)),
        duration: Duration(milliseconds: 200),
        child: TextButton(
          onPressed: (currentPage == totalPage - 1)
              ? onPageFinish
              : () {
                  _goToNextPage(context);
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                (currentPage == totalPage - 1) ? buttonFinishText : buttonText,
                style: (currentPage == totalPage - 1) ? buttonFinishTextStyle : buttonTextStyle,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  (currentPage == totalPage - 1) ? iconButtonBottomFinish : iconButtonBottom,
                  color: colorIconButtonBottom,
                  size: iconSize,
                ),
              )
            ],
          ),
          style: ButtonStyle(
            padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
              (Set<MaterialState> states) {
                return EdgeInsets.symmetric(vertical: 6, horizontal: 16);
              },
            ),
          ),
        ));
  }

  /// Switch to Next Slide using the Floating Action Button.
  void _goToNextPage(BuildContext context) {
    pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}
