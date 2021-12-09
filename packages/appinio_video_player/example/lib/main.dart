import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
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
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(longVideo)
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text("Customized Icons",
                  style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
              const SizedBox(
                height: 20,
              ),
              CustomVideoPlayer(
                customVideoPlayerController: customVideoPlayerController,
                videoPlayerController: videoPlayerController,
                customVideoPlayerSettings: CustomVideoPlayerSettings(
                  //TODO: play around with these paramters

                  // controlBarAvailable: true,
                  // controlBarMargin:const EdgeInsets.all(10),
                  // controlBarPadding: const EdgeInsets.all(0),
                  // showPlayButton: true,
                  // playButton: const Icon(
                  //   Icons.play_circle,
                  //   color: Colors.white,
                  // ),
                  // pauseButton: const Icon(
                  //   Icons.pause_circle,
                  //   color: Colors.white,
                  // ),
                  // enterFullscreenButton: const Icon(
                  //   Icons.fullscreen,
                  //   color: Colors.white,
                  // ),
                  // exitFullscreenButton: const Icon(
                  //   Icons.fullscreen_exit,
                  //   color: Colors.white,
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
      ),
    );
  }
}
