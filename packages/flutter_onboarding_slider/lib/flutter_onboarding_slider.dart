library flutter_onboarding_slider;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/background_controller.dart';
import 'package:flutter_onboarding_slider/background_final_button.dart';
import 'package:flutter_onboarding_slider/header_onboaring_slider.dart';
import 'package:flutter_onboarding_slider/page_offset_provider.dart';
import 'package:provider/provider.dart';

import 'background_body.dart';

class OnBoardingSlider extends StatefulWidget {
  /// Number of total pages.
  final int totalPage;

  /// Callback to be executed when clicked on the [finishButton].
  final Function()? onFinish;

  /// NavigationBar trailing widget when not on last screen.
  final String skipTextButton;

  /// Color of the bottom button on the last page.
  final Color? customColorButton;

  /// Text inside last pages bottom button.
  final String finishButtonText;

  /// Text inside last pages bottom button.
  final String buttonBottomText;

  /// Text style for text inside last pages bottom button.
  final TextStyle finishButtonTextStyle;

  /// Text style for text title.
  final TextStyle titleStyle;

  /// Text style for text title.
  final TextStyle descriptionStyle;

  /// Color of the bottom page indicators.
  final Color? controllerColor;

  /// Color of text title
  final Color? customColorTitle;

  /// Color of text description.
  final Color? customColorDescription;

  /// Toggle bottom page controller visibilty.
  final bool addController;

  /// is the indicator located on top of the screen
  final bool indicatorAbove;

  /// distance of indicator from bottom
  final double indicatorPosition;

  /// distance of indicator from bottom
  final double paddingBottom;

  /// override the function for kip button in the navigator.
  final Function()? skipFunction;

  final Function(int) changePage;
  final bool showButtonBottom;
  final List<SlideOnBoarding> slides;
  final EdgeInsets paddingHeader;
  final EdgeInsets paddingContent;
  final EdgeInsets paddingButton;
  final EdgeInsets paddingImage;
  final IconData? iconButtonBottomFinish;
  final IconData? iconButtonBottom;
  final double heightButtonBottom;
  final double widthButtonBottom;
  final double iconButtonBottomSize;
  OnBoardingSlider({
    required this.totalPage,
    required this.changePage,
    required this.slides,
    this.onFinish,
    this.skipTextButton = '',
    this.customColorButton,
    this.finishButtonText = '',
    this.buttonBottomText = '',
    this.controllerColor,
    this.customColorTitle,
    this.customColorDescription,
    this.addController = false,
    this.paddingBottom = 35,
    this.finishButtonTextStyle = const TextStyle(
      fontSize: 14,
    ),
    this.indicatorAbove = false,
    this.indicatorPosition = 90,
    this.skipFunction,
    this.iconButtonBottomFinish,
    this.iconButtonBottom,
    this.iconButtonBottomSize = 20,
    this.heightButtonBottom = 40,
    this.widthButtonBottom = 130,
    this.showButtonBottom = true,
    this.paddingHeader = EdgeInsets.zero,
    this.paddingButton = EdgeInsets.zero,
    this.paddingContent = EdgeInsets.zero,
    this.paddingImage = EdgeInsets.zero,
    this.titleStyle = const TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 28,
    ),
    this.descriptionStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 15,
    ),
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
      child: CupertinoPageScaffold(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: widget.slides[_currentPage].gradient ?? null,
            color: widget.slides[_currentPage].background ?? null,
          ),
          child: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: widget.paddingHeader,
                    child: HeaderOnBoaringSlider(
                      currentPage: _currentPage,
                      slides: widget.slides,
                      onSkip: widget.skipFunction,
                      textButtonSkip: widget.skipTextButton,
                      isLightMode: widget.slides[_currentPage].isLightMode,
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: BackgroundBody(
                      controller: _pageController,
                      function: slide,
                      totalPage: widget.totalPage,
                      bodies: _getListContentPage(),
                    ),
                  )),
                  widget.addController
                      ? BackgroundController(
                          indicatorPosition: widget.indicatorPosition,
                          indicatorAbove: widget.indicatorAbove,
                          currentPage: _currentPage,
                          totalPage: widget.totalPage,
                          controllerColor: widget.controllerColor,
                        )
                      : SizedBox.shrink(),
                if (widget.showButtonBottom)
                  Padding(
                    padding: widget.paddingButton,
                    child: BackgroundFinalButton(
                        totalPage: widget.totalPage,
                        currentPage: _currentPage,
                        pageController: _pageController,
                        buttonText: widget.buttonBottomText,
                        buttonFinishText: widget.finishButtonText,
                        onPageFinish: widget.onFinish,
                        colorIconButtonBottom: widget.slides[_currentPage].isLightMode ? Colors.white : Colors.black,
                        iconButtonBottomFinish: widget.iconButtonBottomFinish,
                        iconButtonBottom: widget.iconButtonBottom,
                        iconSize: widget.iconButtonBottomSize,
                        heightButtonBottom: widget.heightButtonBottom,
                        widthButtonBottom: widget.widthButtonBottom,
                        buttonBackgroundColor: _backgroundColorButton(),
                        buttonFinishTextStyle: widget.finishButtonTextStyle
                            .copyWith(color: widget.slides[_currentPage].isLightMode ? Colors.white : Colors.black),
                        buttonTextStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: widget.slides[_currentPage].isLightMode ? Colors.white : Colors.black)),
                  ),
                  SizedBox(
                    height: widget.paddingBottom,
                  )
                ]),
          ),
        ),
      ),
    );
  }

  /// Background color button bottom
  Color? _backgroundColorButton() {
    if (widget.customColorButton != null) {
      return widget.customColorButton;
    } else {
      return widget.slides[_currentPage].isLightMode ? Colors.black : Colors.white;
    }
  }

  /// Slide to Next Page.
  void slide(int page) {
    setState(() {
      _currentPage = page;
    });
    widget.changePage(page);
  }

  /// Skip to last Slide.
  void _onSkip() {
    _pageController.jumpToPage(widget.totalPage - 1);
    setState(() {
      _currentPage = widget.totalPage - 1;
    });
  }

  /// Get list Content page
  List<Widget> _getListContentPage() {
    List<Widget> widgets = [];
    return widget.slides.map((e) {
      return SizedBox(
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Padding(
                  padding: widget.paddingImage,
                  child: Center(
                    child: Image.asset(e.image),
                  ),
                )),
            Expanded(
              child: Padding(
                padding: widget.paddingContent,
                child: Column(
                  children: [
                    Text(
                      e.title,
                      style: widget.titleStyle.copyWith(
                          color: widget.customColorTitle == null
                              ? e.isLightMode
                                  ? Colors.black
                                  : Colors.white
                              : widget.customColorTitle),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        e.description,
                        style: widget.descriptionStyle.copyWith(
                            color: widget.customColorDescription == null
                                ? e.isLightMode
                                    ? Color(0xff757575)
                                    : Colors.white
                                : widget.customColorDescription),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }).toList();
  }
}

class SlideOnBoarding {
  Color? background;
  Gradient? gradient;
  String image;
  String title;
  String description;
  bool isLightMode;
  SlideOnBoarding(
      {this.background,
      this.gradient,
      required this.image,
      required this.title,
      required this.description,
      this.isLightMode = false});
}
