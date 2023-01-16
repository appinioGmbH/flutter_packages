//for type safety
import 'enums.dart';

typedef AppinioSwiperOnSwipe = void Function(
    int index, AppinioSwiperDirection direction);
typedef AppinioSwiperOnUnswipe = void Function(bool unswiped);
typedef AppinioSwiperOnEnd = void Function();
typedef AppinioSwiperOnTapDisabled = void Function();
