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
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  String videoUrlLandscape =
      "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
  String videoUrlPortrait =
      'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4';
  String longVideo =
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(
    //TODO: play around with these parameters

    controlBarAvailable: true,
    // controlBarMargin: const EdgeInsets.all(10),
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
    // durationRemainingTextStyle: const TextStyle(color: Colors.red),
    // durationPlayedTextStyle: const TextStyle(color: Colors.green),
    // systemUIModeAfterFullscreen: SystemUiMode.leanBack,
    // systemUIModeInsideFullscreen: SystemUiMode.edgeToEdge,
    // customVideoPlayerProgressBarSettings:
    //     const CustomVideoPlayerProgressBarSettings(
    //   reachableProgressBarPadding: EdgeInsets.all(10),
    //   progressBarHeight: 10,
    //   progressBarBorderRadius: 30,
    //   bufferedColor: Colors.red,
    //   progressColor: Colors.green,
    //   backgroundColor: Colors.purple,
    //   allowScrubbing: false,
    //   showProgressBar: false,
    // ),
  );

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(longVideo)
      ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _customVideoPlayerController.dispose();
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
              CustomVideoPlayer(
                customVideoPlayerController: CustomVideoPlayerController(
                  context: context,
                  videoPlayerController: _videoPlayerController,
                  customVideoPlayerSettings: _customVideoPlayerSettings,
                ),
              ),
              CupertinoButton(
                child: const Text("Play Fullscreen"),
                onPressed: () {
                  _customVideoPlayerController.playPause();
                  _customVideoPlayerController.setFullscreen(true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
