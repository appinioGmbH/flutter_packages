import 'package:flutter/cupertino.dart';
import 'package:widget_zoom/widget_zoom.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Appinio Zoom Widget'),
      ),
      child: Center(
        child: WidgetZoom(
          heroAnimationTag: 'tag',
          zoomWidget: Image.network(
            'https://i.picsum.photos/id/161/1200/1200.jpg?hmac=Wah6VuM-bdIJPMP9gOppMBBFBr2FtYVRU7pCH_yONdM',
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
