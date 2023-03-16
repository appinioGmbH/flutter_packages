import 'package:flutter/cupertino.dart';
import 'enums.dart';

typedef CardsBuilder = Widget Function(BuildContext context, int index);

typedef OnSwipe = void Function(int index, AppinioSwiperDirection direction);

typedef OnUnSwipe = void Function(bool unswiped);
