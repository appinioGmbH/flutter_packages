import 'package:flutter/cupertino.dart';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:example/example_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: Example(),
    );
  }
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<Example> {
  final AppinioSwiperController controller = AppinioSwiperController();

  List<ExampleCard> images = [];
  List<String> text = [
    'assets/humaaans_2.jpg',
    'assets/humaaans_3.jpg',
    'assets/humaaans_4.jpg',
    'assets/humaaans_6.jpg',
    'assets/humaaans_5.jpg',
    'assets/humaaans_8.jpg',
    'assets/humaaans_10.jpg',
    'assets/humaaans_11.jpg',
    'assets/humaaans_12.jpg',
    'assets/humaaans_1.jpg',
  ];

  @override
  void initState() {
    _loadCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFE9EFF2),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: AppinioSwiper(
              controller: controller,
              cards: images,
              onSwipe: _swipe,
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 50,
                bottom: 40,
              ),
            ),
          ),
          CupertinoButton(
            child: const Text("swipe"),
            color: const Color(0xFF053149),
            onPressed: () => controller.swipe(),
          ),
          const SizedBox(
            height: 10,
          ),
          CupertinoButton(
            child: const Text("unswipe"),
            color: const Color(0xFF053149),
            onPressed: () => controller.unswipe(),
          ),
        ],
      ),
    );
  }

  void _swipe(int index) {
    //print("swipe");
  }

  void _loadCards() {
    for (String text in text) {
      images.add(ExampleCard(image: text));
    }
  }
}
