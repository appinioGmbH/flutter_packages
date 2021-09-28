library flutter_onboarding_slider;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/background_controller.dart';
import 'package:flutter_onboarding_slider/background_final_button.dart';
import 'package:flutter_onboarding_slider/navigation_bar.dart';
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

  /// Color of the text inside the [finishButton].
  final Color? buttonTextColor;

  /// Text inside last pages bottom button.
  final String? finishButtonText;

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

  /// Height of the foreground content of the page.
  final double bodyHeight;

  /// Width of the foreground content of the page.
  final double bodyWidth;

  /// Width of the foreground content of the page.
  final Widget? leading;

  /// Width of the foreground content of the page.
  final Widget? middle;

  OnBoardingSlider({
    required this.totalPage,
    required this.headerBackgroundColor,
    required this.background,
    required this.speed,
    this.onFinish,
    this.trailingFunction,
    this.trailing,
    this.skipTextButton,
    this.pageBackgroundColor,
    this.pageBackgroundGradient,
    required this.pageBodies,
    this.finishButtonColor,
    this.buttonTextColor,
    this.finishButtonText,
    this.controllerColor,
    this.addController = true,
    this.addButton = true,
    this.imageVerticalOffset = 0,
    this.imageHorizontalOffset = 0,
    this.bodyHeight = 200,
    this.bodyWidth = 200,
    this.leading,
    this.middle,
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
        floatingActionButton: BackgroundFinalButton(
          addButton: widget.addButton,
          currentPage: _currentPage,
          pageController: _pageController,
          totalPage: widget.totalPage,
          onPageFinish: widget.onFinish,
          buttonBackgroundColor: widget.finishButtonColor,
          buttonTextColor: widget.buttonTextColor,
          buttonText: widget.finishButtonText,
        ),
        body: CupertinoPageScaffold(
          navigationBar: NavigationBar(
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
                    BackgroundBody(
                      bodyHeight: widget.bodyHeight,
                      bodyWidth: widget.bodyWidth,
                      controller: _pageController,
                      function: slide,
                      totalPage: widget.totalPage,
                      bodies: widget.pageBodies,
                    ),
                    widget.addController
                        ? BackgroundController(
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
