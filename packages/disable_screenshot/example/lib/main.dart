import 'package:flutter/material.dart';
import 'dart:async';
import 'package:disable_screenshot/disable_screenshot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: RootApp());
  }
}

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  RootAppState createState() => RootAppState();
}

class RootAppState extends State<RootApp> {
  final DisableScreenshot _plugin = DisableScreenshot();
  late StreamSubscription<void> _screenshotsSubscription;
  int _screenshotsCount = 0;
  bool _disableScreenshots = false;

  @override
  void initState() {
    super.initState();
    _screenshotsSubscription = _plugin.onScreenShots().listen((event) {
      setState(() {
        _screenshotsCount++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disable Screenshot'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 100),
          Center(
            child: Text("counts：$_screenshotsCount"),
          ),
          Center(
            child: Text(_disableScreenshots ? "disabled" : "allowed"),
          ),
          GestureDetector(
              onTap: () async {
                bool flag = !_disableScreenshots;
                await _plugin.disableScreenshots(flag);
                setState(() {
                  _disableScreenshots = flag;
                });
              },
              child: Text(_disableScreenshots
                  ? "allow screenshot"
                  : "disable screenshot")),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_screenshotsSubscription != null) {
      _screenshotsSubscription.cancel();
    }
  }
}
