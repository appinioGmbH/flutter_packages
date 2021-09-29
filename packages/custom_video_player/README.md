# Custom Video Player

This package wraps the official video_player package by flutter and extends it with a fully customisable control bar and a fullscreen mode. For the control bar you can decide for each element if you want to show it and if so how it should look.

<br />

## Top Features

* Fullscreen Mode
* Fully Customizable Controls
* Fluid Progress Bar
* Prevent Seeking in Progress Bar

<br />

## Preview
  <img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/video_player/screenshot_1.png?raw=true" height="600" /> <img src="https://github.com/appinioGmbH/flutter_packages/blob/main/assets/video_player/screenshot_2.png?raw=true" height="600" />

<br />

## Getting started

- To get started just create a VideoPlayerController as you would for the normal video_player and define a source to use.
- Secondly create a CustomVideoPlayerController to access the fullscreen and control bar visibility switches by yourself. Pass the controllers to a CustomVideoPlayer widget to use all its functionality and customisation oppurtunities.
- On the examples tab you can see all parameters you can customize to your needs.

<br />

## Usage

```dart
class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController videoPlayerController;
  CustomVideoPlayerController customVideoPlayerController =
      CustomVideoPlayerController();

  String videoUrl =
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

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

<hr/>
Made with ❤ by Flutter team at <a href="https://appinio.com">Appinio GmbH</a>
