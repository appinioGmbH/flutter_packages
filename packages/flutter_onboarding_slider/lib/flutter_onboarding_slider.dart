library flutter_onboarding_slider;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/background_controller.dart';
import 'package:flutter_onboarding_slider/background_final_button.dart';
import 'package:flutter_onboarding_slider/onboarding_navigation_bar.dart';
import 'package:flutter_onboarding_slider/page_offset_provider.dart';
import 'package:provider/provider.dart';

import 'background.dart';
import 'background_body.dart';
export 'background.dart';

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
  final Color? pageBackgroundColor;

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

  /// Color of the bottom button on the last page.
  final Color? finishButtonColor;

  /// Text inside last pages bottom button.
  final String? finishButtonText;

  /// Text style for text inside last pages bottom button.
  final TextStyle finishButtonTextStyle;

  /// Color of the bottom page indicators.
  final Color? controllerColor;

  /// Toggle bottom button.
  final bool addButton;

  /// Toggle bottom page controller visibilty.
  final bool addController;

  /// Defines the vertical offset of the [background].
  final double imageVerticalOffset;

  /// Defines the horizontal offset of the [background].
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

  OnBoardingSlider({
    required this.totalPage,
    required this.headerBackgroundColor,
    required this.background,
    required this.speed,
    required this.pageBodies,
    this.onFinish,
    this.trailingFunction,
    this.trailing,
    this.skipTextButton,
    this.pageBackgroundColor,
    this.pageBackgroundGradient,
    this.finishButtonColor,
    this.finishButtonText,
    this.controllerColor,
    this.addController = true,
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
  _OnBoardingSliderState createState() => _OnBoardingSliderState();
}

class _OnBoardingSliderState extends State<OnBoardingSlider> {
  final PageController _pageController = PageController(initialPage: 0);

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => PageOffsetNotifier(_pageController),
      child: Scaffold(
        backgroundColor: widget.pageBackgroundColor ?? null,
        floatingActionButton: widget.hasFloatingButton
            ? BackgroundFinalButton(
                buttonTextStyle: widget.finishButtonTextStyle,
                skipIcon: widget.skipIcon,
                addButton: widget.addButton,
                currentPage: _currentPage,
                pageController: _pageController,
                totalPage: widget.totalPage,
                onPageFinish: widget.onFinish,
                buttonBackgroundColor: widget.finishButtonColor,
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
            currentPage: _currentPage,
            onSkip: _onSkip,
            headerBackgroundColor: widget.headerBackgroundColor,
            onFinish: widget.trailingFunction,
            finishButton: widget.trailing,
            skipTextButton: widget.skipTextButton,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: widget.pageBackgroundGradient ?? null,
              color: widget.pageBackgroundColor ?? null,
            ),
            child: SafeArea(
              child: Background(
                imageHorizontalOffset: widget.imageHorizontalOffset,
                imageVerticalOffset: widget.imageVerticalOffset,
                background: widget.background,
                speed: widget.speed,
                totalPage: widget.totalPage,
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
                              indicatorPosition: widget.indicatorPosition,
                              indicatorAbove: widget.indicatorAbove,
                              currentPage: _currentPage,
                              totalPage: widget.totalPage,
                              controllerColor: widget.controllerColor,
                            )
                          : SizedBox.shrink(),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Slide to Next Page.
  void slide(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  /// Skip to last Slide.
  void _onSkip() {
    _pageController.jumpToPage(widget.totalPage - 1);
    setState(() {
      _currentPage = widget.totalPage - 1;
    });
  }
}
