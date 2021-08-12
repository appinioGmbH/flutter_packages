import 'package:flutter/material.dart';

class BackgroundFinalButton extends StatelessWidget {
  final int currentPage;
  final PageController pageController;
  final int totalPage;
  final bool addButton;
  final Function? onPageFinish;
  final Color? buttonBackgroundColor;
  final Color? buttonTextColor;
  final String? buttonText;

  BackgroundFinalButton({
    required this.currentPage,
    required this.pageController,
    required this.totalPage,
    this.onPageFinish,
    this.buttonBackgroundColor,
    this.buttonTextColor,
    this.buttonText,
    required this.addButton,
  });

  @override
  Widget build(BuildContext context) {
    return addButton
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
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    onPressed: () =>
                        onPageFinish == null ? () {} : onPageFinish!(context),
                    elevation: 0,
                    label: buttonText == null
                        ? SizedBox.shrink()
                        : Text(
                            buttonText!,
                            style: TextStyle(
                              fontSize: 20,
                              color: buttonTextColor,
                              letterSpacing: 0,
                            ),
                          ),
                    backgroundColor: buttonBackgroundColor,
                  )
                : FloatingActionButton(
                    onPressed: () => _goToNextPage(context),
                    elevation: 0,
                    child: Icon(
                      Icons.arrow_forward,
                      color: buttonTextColor,
                    ),
                    backgroundColor: buttonBackgroundColor,
                  ),
          )
        : SizedBox.shrink();
  }

  void _goToNextPage(BuildContext context) {
    pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}
