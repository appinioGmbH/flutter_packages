/*
The MIT License (MIT)

Copyright (c) 2021 APPINIO GmbH

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'background.dart';
import 'background_body.dart';
import 'background_controller.dart';
import 'background_final_button.dart';
import 'onboarding_navigation_bar.dart';

export 'background.dart';
export 'background_final_button.dart';

class OnBoardingSlider extends StatefulWidget {
  /// Number of total pages.
  final int totalPage;

  /// NavigationBars color.
  final Color headerBackgroundColor;

  /// List of Widgets to be shown in the backgrounds of the pages. For example a picture or some illustration.
  final List<Widget> background;

  /// The speed of the animation for the [background].
  final double speed;

  /// Background Color of whole screen apart from the NavigationBar.
  final Color pageBackgroundColor;

  /// Background Gradient of whole screen apart from the NavigationBar.
  final Gradient? pageBackgroundGradient;

  /// Callback to be executed when clicked on the [finishButton].
  final Function? onFinish;

  /// NavigationBar trailing widget when on last screen.
  final Widget? trailing;

  /// NavigationBar trailing widget when not on last screen.
  final Widget? skipTextButton;

  /// The main content ont the screen displayed above the [background].
  final List<Widget> pageBodies;

  /// Callback to be executed when clicked on the last pages bottom button.
  final Function? trailingFunction;

  /// Style of the bottom button on the last page.
  final FinishButtonStyle? finishButtonStyle;

  /// Text inside last pages bottom button.
  final String? finishButtonText;

  /// Text style for text inside last pages bottom button.
  final TextStyle finishButtonTextStyle;

  /// Color of the bottom page indicators.
  final Color? controllerColor;

  /// Toggle bottom button.
  final bool addButton;

  /// Center [background].
  /// Do not pass [imageHorizontalOffset] when you turn this flag to true otherwise that will get ignored
  final bool centerBackground;

  /// Toggle bottom page controller visibilty.
  final bool addController;

  /// Defines the vertical offset of the [background].
  final double imageVerticalOffset;

  /// Defines the horizontal offset of the [background].
  /// Do not set [centerBackground] to true when you use this property otherwise this will get ignored
  final double imageHorizontalOffset;

  /// leading widget in the navigationBar.
  final Widget? leading;

  /// middle widget in the navigationBar.
  final Widget? middle;

  /// Whether has the floating action button to skip and the finish button
  final bool hasFloatingButton;

  /// Whether has the skip button in the bottom;
  final bool hasSkip;

  /// icon on the skip button
  final Icon skipIcon;

  /// is the indicator located on top of the screen
  final bool indicatorAbove;

  /// distance of indicator from bottom
  final double indicatorPosition;

  /// override the function for kip button in the navigator.
  final Function? skipFunctionOverride;

  const OnBoardingSlider({
    super.key,
    required this.totalPage,
    required this.headerBackgroundColor,
    required this.background,
    required this.speed,
    required this.pageBodies,
    required this.pageBackgroundColor,
    this.onFinish,
    this.trailingFunction,
    this.trailing,
    this.skipTextButton,
    this.pageBackgroundGradient,
    this.finishButtonStyle,
    this.finishButtonText,
    this.controllerColor,
    this.addController = true,
    this.centerBackground = false,
    this.addButton = true,
    this.imageVerticalOffset = 0,
    this.imageHorizontalOffset = 0,
    this.leading,
    this.middle,
    this.hasFloatingButton = true,
    this.hasSkip = true,
    this.finishButtonTextStyle = const TextStyle(
      fontSize: 20,
      color: Colors.white,
    ),
    this.skipIcon = const Icon(
      Icons.arrow_forward,
      color: Colors.white,
    ),
    this.indicatorAbove = false,
    this.indicatorPosition = 90,
    this.skipFunctionOverride,
  });

  @override
  OnBoardingSliderState createState() => OnBoardingSliderState();
}

class OnBoardingSliderState extends State<OnBoardingSlider> {
  final PageController _pageController = PageController(initialPage: 0);

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.pageBackgroundColor,
      floatingActionButton: widget.hasFloatingButton
          ? BackgroundFinalButton(
              buttonTextStyle: widget.finishButtonTextStyle,
              skipIcon: widget.skipIcon,
              addButton: widget.addButton,
              currentPage: currentPage,
              pageController: _pageController,
              totalPage: widget.totalPage,
              onPageFinish: widget.onFinish,
              finishButtonStyle: widget.finishButtonStyle,
              buttonText: widget.finishButtonText,
              hasSkip: widget.hasSkip,
            )
          : SizedBox.shrink(),
      body: CupertinoPageScaffold(
        navigationBar: OnBoardingNavigationBar(
          skipFunctionOverride: widget.skipFunctionOverride,
          leading: widget.leading,
          middle: widget.middle,
          totalPage: widget.totalPage,
          currentPage: currentPage,
          onSkip: _onSkip,
          headerBackgroundColor: widget.headerBackgroundColor,
          onFinish: widget.trailingFunction,
          finishButton: widget.trailing,
          skipTextButton: widget.skipTextButton,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: widget.pageBackgroundGradient,
            color: widget.pageBackgroundColor,
          ),
          child: SafeArea(
            child: Background(
              centerBackground: widget.centerBackground,
              imageHorizontalOffset: widget.imageHorizontalOffset,
              imageVerticalOffset: widget.imageVerticalOffset,
              background: widget.background,
              speed: widget.speed,
              totalPage: widget.totalPage,
              pageController: _pageController,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: BackgroundBody(
                        controller: _pageController,
                        function: slide,
                        totalPage: widget.totalPage,
                        bodies: widget.pageBodies,
                      ),
                    ),
                    widget.addController
                        ? BackgroundController(
                            backgroundColor: widget.pageBackgroundColor,
                            hasFloatingButton: widget.hasFloatingButton,
                            indicatorPosition: widget.indicatorPosition,
                            indicatorAbove: widget.indicatorAbove,
                            currentPage: currentPage,
                            totalPage: widget.totalPage,
                            controllerColor: widget.controllerColor,
                          )
                        : SizedBox.shrink(),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  /// Slide to Next Page.
  void slide(int page) {
    setState(() {
      currentPage = page;
    });
  }

  /// Skip to last Slide.
  void _onSkip() {
    _pageController.jumpToPage(widget.totalPage - 1);
    setState(() {
      currentPage = widget.totalPage - 1;
    });
  }
}
