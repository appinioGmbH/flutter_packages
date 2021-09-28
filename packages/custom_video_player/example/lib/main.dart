import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_video_player/custom_video_player.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(
        brightness: Brightness.light,
      ),
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Custom Video Player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController videoPlayerController;
  CustomVideoPlayerController customVideoPlayerController =
      CustomVideoPlayerController();

  String videoUrlLandscape =
      "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
  String videoUrlPortrait =
      'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4';

  String longVideo =
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(videoUrlPortrait)
      ..initialize();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            CustomVideoPlayer(
              customVideoPlayerController: customVideoPlayerController,
              videoPlayerController: videoPlayerController,
              customVideoPlayerSettings: CustomVideoPlayerSettings(
                //TODO: play around with these paramters

                // controlBarAvailable: true,
                // controlBarMargin:const EdgeInsets.all(10),
                // controlBarPadding: const EdgeInsets.all(0),
                // showPlayButton: true,
                // playButton: Container(
                //   width: 30,
                //   height: 30,
                //   color: Colors.green,
                // ),
                // pauseButton: Container(
                //   width: 30,
                //   height: 30,
                //   color: Colors.red,
                // ),
                // enterFullscreenButton: Container(
                //   width: 30,
                //   height: 30,
                //   color: Colors.yellow,
                // ),
                // exitFullscreenButton: Container(
                //   width: 30,
                //   height: 30,
                //   color: Colors.purple,
                // ),
                // controlBarDecoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(50),
                //   color: Colors.blue,
                // ),
                // showFullscreenButton: false,
                // showDurationPlayed: false,
                // showDurationRemaining: false,
                // enterFullscreenOnStart: true,
                // exitFullscreenOnEnd: true,
                // durationRemainingTextStyle:
                //     const TextStyle(color: Colors.red),
                // durationPlayedTextStyle: const TextStyle(color: Colors.green),
                // systemUIModeAfterFullscreen: SystemUiMode.leanBack
                // systemUIModeInsideFullscreen: SystemUiMode.edgeToEdge,
                customVideoPlayerProgressBarSettings:
                    const CustomVideoPlayerProgressBarSettings(
                        // reachableProgressBarPadding: EdgeInsets.all(10),
                        // progressBarHeight: 10,
                        // progressBarBorderRadius: 30,
                        // progressBarColors: CustomVideoPlayerProgressBarColors(
                        //   bufferedColor: Colors.red,
                        //   progressColor: Colors.green,
                        //   backgroundColor: Colors.purple,
                        // ),
                        // allowScrubbing: false,
                        // showProgressBar: false,
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
