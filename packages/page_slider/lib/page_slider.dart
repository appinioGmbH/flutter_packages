library page_slider;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_slider/background_controller.dart';
import 'package:page_slider/background_final_button.dart';
import 'package:page_slider/navigation_bar.dart';
import 'package:page_slider/page_offset_provider.dart';
import 'package:provider/provider.dart';

import 'background.dart';
import 'background_body.dart';
export 'background.dart';

class PageSlider extends StatefulWidget {
  int totalPage;
  Color headerBackgroundColor;
  List<Widget> background;
  double speed;
  bool addButton;
  Color? pageBackgroundColor;
  Gradient? pageBackgroundGradient;
  Function? onFinish;
  Widget? finishButton;
  Widget? skipTextButton;
  List<Widget> pageBodies;
  Function? onPageFinish;
  Color? buttonBackgroundColor;
  Color? buttonTextColor;
  String? buttonText;
  Color? controllerColor;
  bool addController;
  double imageVerticalOffset;
  double bodyHeight;
  double bodyWidth;

  PageSlider({
    required this.totalPage,
    required this.headerBackgroundColor,
    required this.background,
    required this.speed,
    this.onFinish,
    this.finishButton,
    this.skipTextButton,
    this.pageBackgroundColor,
    this.pageBackgroundGradient,
    required this.pageBodies,
    this.onPageFinish,
    this.buttonBackgroundColor,
    this.buttonTextColor,
    this.buttonText,
    this.controllerColor,
    this.addController = true,
    this.addButton = true,
    this.imageVerticalOffset = 0,
    this.bodyHeight = 200,
    this.bodyWidth = 200,
  });

  @override
  _PageSliderState createState() => _PageSliderState();
}

class _PageSliderState extends State<PageSlider> {
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
        appBar: NavigationBar(
          totalPage: widget.totalPage,
          currentPage: _currentPage,
          onSkip: _onSkip,
          headerBackgroundColor: widget.headerBackgroundColor,
          onFinish: widget.onFinish,
          finishButton: widget.finishButton,
          skipTextButton: widget.skipTextButton,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: widget.pageBackgroundGradient ?? null,
            color: widget.pageBackgroundColor ?? null,
          ),
          child: Background(
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
        floatingActionButton: BackgroundFinalButton(
          addButton: widget.addButton,
          currentPage: _currentPage,
          pageController: _pageController,
          totalPage: widget.totalPage,
          onPageFinish: widget.onPageFinish,
          buttonBackgroundColor: widget.buttonBackgroundColor,
          buttonTextColor: widget.buttonTextColor,
          buttonText: widget.buttonText,
        ),
      ),
    );
  }

  void slide(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onSkip() {
    _pageController.jumpToPage(widget.totalPage - 1);
    setState(() {
      _currentPage = widget.totalPage - 1;
    });
  }
}
