# Custom Video Player

This package wraps the official video_player package by flutter and extends it with a fully customisable control bar and a fullscreen mode for mobile. For the control bar you can decide for each element if you want to show it and if so how it should look. 
## Getting started

To get started just create a VideoPlayerController as you would for the normal video_player and define a source to use. Secondly create a CustomVideoPlayerController to access the fullscreen and control bar visibility switches by yourself. Pass the controllers to the a CustomVideoPlayer widget to use all its functionality and customisation oppurtunities. On the examples tab you can see all parameters you can customize to your needs.

## Usage

```dart
class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController videoPlayerController;
  CustomVideoPlayerController customVideoPlayerController =
      CustomVideoPlayerController();

  String videoUrl =
      "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(videoUrl)
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
        child: CustomVideoPlayer(
          customVideoPlayerController: customVideoPlayerController,
          videoPlayerController: videoPlayerController,
        ),
      ),
    );
  }
}
```

