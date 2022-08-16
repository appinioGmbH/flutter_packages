import 'package:flutter/material.dart';
import 'dart:async';
import 'package:disable_screenshot/disable_screenshot.dart';

import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: RootApp());
  }
}

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  DisableScreenshot _plugin = DisableScreenshot();
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
          SizedBox(height: 100),
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
