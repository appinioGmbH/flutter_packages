library flutter_scrollable_listview_popup;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scrollable_listview_popup/triangle.dart';

class FlutterScrollableListvewPopup extends StatefulWidget {
  final Function(int)? onSelect;
  final List<Widget> children;
  final double height;
  final Duration duration;
  final String notification;

  const FlutterScrollableListvewPopup({
    Key? key,
    this.onSelect,
    this.duration = const Duration(milliseconds: 200),
    required this.children,
    required this.height,
    required this.notification,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FlutterScrollableListvewPopupState();
}

class _FlutterScrollableListvewPopupState
    extends State<FlutterScrollableListvewPopup> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  double x = 0;
  bool isPopup = false;
  int currentIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBar(),
        _buildPopup(),
      ],
    );
  }

  Widget _buildBar() {
    return Container(
      height: widget.height,
      child: NotificationListener(
        onNotification: (t) {
          setState(() {
            isPopup = false;
          });
          return true;
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: widget.children.length,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (index == currentIndex) {
                    if (widget.onSelect != null) widget.onSelect!(index);
                    currentIndex = -1;
                    isPopup = false;
                  } else {
                    currentIndex = index;
                    isPopup = true;
                  }
                });
              },
              child: widget.children[index],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPopup() {
    return AnimatedSize(
      duration: widget.duration,
      curve: Curves.easeIn,
      child: Container(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
        height: isPopup ? 80 : 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 10,
              margin: EdgeInsets.only(left: x <= 20 ? 0 : x + 7),
              child: CustomPaint(
                painter: TrianglePainter(
                  strokeColor: Colors.blueGrey,
                  strokeWidth: 1,
                  paintingStyle: PaintingStyle.fill,
                ),
              ),
            ),
            Center(
              child: Container(
                width: 340,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  widget.notification,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// For controlling the automatic scrolling of the bar when item out of range
  /// or when the bar is below the view to show popup
  /// And set the color
  Future<void> notAvailable(int number, GlobalKey key, String notification,
      String svg, Color color) async {
    RenderObject? box = key.currentContext!.findRenderObject();
    Offset position = box.localToGlobal(Offset.zero);
    if (position.dx < 25) {
      await _scrollController
          .animateTo(
        _scrollController.offset - 200,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      )
          .then((value) async {
        RenderBox box = colorKey.currentContext.findRenderObject();
        Offset position = box.localToGlobal(Offset.zero);
        setState(() {
          x = position.dx;
          this.notification = notification;
          this.svg = svg;
          bubbleColor = color;
        });
      });
    } else if (position.dx > 270) {
      if (_scrollController.offset >
          _scrollController.position.maxScrollExtent - 100) {
        await _scrollController
            .animateTo(
              _scrollController.offset + 100,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            )
            .then((value) => {
                  setState(() {
                    x = MediaQuery.of(context).size.width - 100;
                    this.notification = notification;
                    this.svg = svg;
                    bubbleColor = color;
                  })
                });
      } else {
        await _scrollController
            .animateTo(
          _scrollController.offset + 100,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        )
            .then((value) async {
          RenderBox box = colorKey.currentContext.findRenderObject();
          Offset position = box.localToGlobal(Offset.zero);
          setState(() {
            x = position.dx;
            this.notification = notification;
            this.svg = svg;
            bubbleColor = color;
          });
        });
      }
    } else {
      setState(() {
        x = position.dx;
        this.notification = notification;
        this.svg = svg;
        bubbleColor = color;
      });
    }
  }
}
