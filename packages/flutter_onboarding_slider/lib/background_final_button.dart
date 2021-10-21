import 'package:flutter/material.dart';

class BackgroundFinalButton extends StatelessWidget {
  final int currentPage;
  final PageController pageController;
  final int totalPage;
  final bool addButton;
  final Function? onPageFinish;
  final Color? buttonBackgroundColor;
  final TextStyle buttonTextStyle;
  final String? buttonText;
  final bool hasSkip;
  final Icon skipIcon;

  BackgroundFinalButton({
    required this.currentPage,
    required this.pageController,
    required this.totalPage,
    this.onPageFinish,
    this.buttonBackgroundColor,
    this.buttonText,
    required this.buttonTextStyle,
    required this.addButton,
    required this.hasSkip,
    required this.skipIcon,
  });

  @override
  Widget build(BuildContext context) {
    return addButton
        ? hasSkip
            ? AnimatedContainer(
                padding: currentPage == totalPage - 1
                    ? EdgeInsets.symmetric(horizontal: 30)
                    : EdgeInsets.all(0),
                width: currentPage == totalPage - 1
                    ? MediaQuery.of(context).size.width - 30
                    : 60,
                duration: Duration(milliseconds: 100),
                child: currentPage == totalPage - 1
                    ? FloatingActionButton.extended(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        onPressed: () => onPageFinish?.call(),
                        elevation: 0,
                        label: buttonText == null
                            ? SizedBox.shrink()
                            : Text(
                                buttonText!,
                                style: buttonTextStyle,
                              ),
                        backgroundColor: buttonBackgroundColor,
                      )
                    : FloatingActionButton(
                        onPressed: () => _goToNextPage(context),
                        elevation: 0,
                        child: skipIcon,
                        backgroundColor: buttonBackgroundColor,
                      ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                width: MediaQuery.of(context).size.width - 30,
                child: FloatingActionButton.extended(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  onPressed: () => onPageFinish?.call(),
                  elevation: 0,
                  label: buttonText == null
                      ? SizedBox.shrink()
                      : Text(
                          buttonText!,
                          style: buttonTextStyle,
                        ),
                  backgroundColor: buttonBackgroundColor,
                ))
        : SizedBox.shrink();
  }

  /// Switch to Next Slide using the Floating Action Button.
  void _goToNextPage(BuildContext context) {
    pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}
