import 'package:flutter/cupertino.dart';
import 'enums.dart';

typedef CardsBuilder = Widget Function(BuildContext context, int index);

typedef OnSwipe = void Function(int previousIndex,int currentIndex, AppinioSwiperDirection direction);

typedef OnUnSwipe = void Function(int? previousIndex,int currentIndex, bool unswiped);
