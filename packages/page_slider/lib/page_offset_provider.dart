import 'package:flutter/cupertino.dart';

class PageOffsetNotifier with ChangeNotifier {
  double _offset = 0;
  double _page = 0;

  PageOffsetNotifier(PageController pageController) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = pageController.page ?? 0;
      notifyListeners();
    });
  }

  double get offset => _offset;
  double get page => _page;
}
