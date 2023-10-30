import 'dart:developer';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:example/example_candidate_model.dart';
import 'package:example/example_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'example_buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: Example(),
    );
  }
}

class Example extends StatefulWidget {
  const Example({
    Key? key,
  }) : super(key: key);

  @override
  State<Example> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<Example> {
  final AppinioSwiperController controller = AppinioSwiperController();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then((_) {
      _shakeCard();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 50,
                bottom: 40,
              ),
              child: AppinioSwiper(
                invertAngleOnBottomDrag: true,
                backgroundCardCount: 3,
                swipeOptions: const SwipeOptions.all(),
                controller: controller,
                unswipe: _unswipe,
                onCardPositionChanged: (
                  AxisDirection direction,
                  Offset position,
                ) {
                  //debugPrint('$direction, $position');
                },
                onSwipe: _swipe,
                onEnd: _onEnd,
                cardCount: candidates.length,
                cardsBuilder: (BuildContext context, int index) {
                  return ExampleCard(candidate: candidates[index]);
                },
              ),
            ),
            IconTheme.merge(
              data: const IconThemeData(size: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TutorialAnimationButton(_shakeCard),
                  const SizedBox(
                    width: 20,
                  ),
                  swipeLeftButton(controller),
                  const SizedBox(
                    width: 20,
                  ),
                  swipeRightButton(controller),
                  const SizedBox(
                    width: 20,
                  ),
                  unswipeButton(controller),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _swipe(int index, AxisDirection direction) {
    log("the card was swiped to the: " + direction.name);
  }

  void _unswipe(bool unswiped) {
    if (unswiped) {
      log("SUCCESS: card was unswiped");
    } else {
      log("FAIL: no card left to unswipe");
    }
  }

  void _onEnd() {
    log("end reached!");
  }

  // Animates the card back and forth to teach the user that it is swipable.
  Future<void> _shakeCard() async {
    const double distance = 30;
    // We can animate back and forth by chaining different animations.
    await controller.animateTo(
      const Offset(-distance, 0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    await controller.animateTo(
      const Offset(distance, 0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    // We need to animate back to the center because `animateTo` does not center
    // the card for us.
    await controller.animateTo(
      const Offset(0, 0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}
