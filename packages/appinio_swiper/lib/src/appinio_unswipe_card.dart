import 'package:flutter/widgets.dart';

class AppinioUnswipeCard {
  Widget widget;
  bool horizontal;
  bool vertical;
  int swipedDirectionHorizontal;
  int swipedDirectionVertical;

  AppinioUnswipeCard({
    required this.widget,
    required this.horizontal,
    required this.vertical,
    required this.swipedDirectionHorizontal,
    required this.swipedDirectionVertical,
  });
}
