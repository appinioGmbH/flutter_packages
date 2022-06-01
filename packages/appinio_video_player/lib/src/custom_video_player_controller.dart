import 'dart:async';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:appinio_video_player/src/fullscreen_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CustomVideoPlayerController {
  final BuildContext context;
  VideoPlayerController videoPlayerController;
  final CustomVideoPlayerSettings customVideoPlayerSettings;
  final Map<String, VideoPlayerController>? additionalVideoSources;
  Function? updateViewAfterFullscreen;

  CustomVideoPlayerController({
    required this.context,
    required this.videoPlayerController,
    this.customVideoPlayerSettings = const CustomVideoPlayerSettings(),
    this.additionalVideoSources,
  }) {
    initialize();
  }

  void initialize() {
    videoPlayerController.addListener(_videoListeners);
  }

  final ValueNotifier<bool> _isPlayingNotifier = ValueNotifier(false);
  ValueNotifier<bool> get isPlayingNotifier => _isPlayingNotifier;

  bool _isFullscreen = false;
  bool get isFullscreen => _isFullscreen;

  final ValueNotifier<Duration> _videoProgressNotifier =
      ValueNotifier(Duration.zero);
  ValueNotifier<Duration> get videoProgressNotifier => _videoProgressNotifier;

  //TODO: make notifier for playback speed

  Timer? _timer;

  Future<void> setFullscreen(
    bool fullscreen,
  ) async {
    if (kIsWeb) {
      debugPrint(
          "Web doesn't support fullscreen properly. When exiting fullscreen the video will be black. Audio still works.");
    }
    if (fullscreen) {
      await _enterFullscreen();
      updateViewAfterFullscreen?.call();
    } else {
      await _exitFullscreen();
    }
  }

  Future<void> _enterFullscreen() async {
    final TransitionRoute<void> route = PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? child) {
              return FullscreenVideoPlayer(
                customVideoPlayerController: this,
              );
            });
      },
    );
    _isFullscreen = true;
    _setOrientationForVideo();
    SystemChrome.setEnabledSystemUIMode(
        customVideoPlayerSettings.systemUIModeInsideFullscreen);
    await Navigator.of(context).push(route);
  }

  Future<void> _exitFullscreen() async {
    await SystemChrome.setEnabledSystemUIMode(
        customVideoPlayerSettings.systemUIModeAfterFullscreen);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); //TODO: dont lock orientation
    _isFullscreen = false;
    Navigator.of(context).pop(this);
  }

  void _setOrientationForVideo() {
    final double videoWidth = videoPlayerController.value.size.width;
    final double videoHeight = videoPlayerController.value.size.height;
    final bool isLandscapeVideo = videoWidth > videoHeight;
    final bool isPortraitVideo = videoWidth < videoHeight;

    /// if video has more width than height set landscape orientation
    if (isLandscapeVideo) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    /// otherwise set portrait orientation
    else if (isPortraitVideo) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    /// if they are equal allow both
    else {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
  }

  Future<void> switchVideoSource(String sourcePath) async {
    Duration _playedDuration = videoPlayerController.value.position;
    videoPlayerController.dispose();
    videoPlayerController = additionalVideoSources!.entries.toList()[1].value;
    await videoPlayerController.initialize();
    initialize(); // add listeners to new video controller
    _setOrientationForVideo(); // if video changed completely
    await videoPlayerController.seekTo(_playedDuration);
    await videoPlayerController.play();
    updateViewAfterFullscreen?.call();
  }

  /// Listeners

  void _videoListeners() {
    _videoProgressListener();
    _fullscreenFunctionalityListener();
    _playPauseListener();
  }

  /// used to make progress more fluid
  Future<void> _videoProgressListener() async {
    if (videoPlayerController.value.isPlaying) {
      _timer ??= Timer.periodic(const Duration(milliseconds: 100),
          (Timer timer) async {
        if (videoPlayerController.value.isInitialized) {
          _videoProgressNotifier.value = await videoPlayerController.position ??
              _videoProgressNotifier.value;
        }
      });
    } else {
      if (_timer != null) {
        _timer?.cancel();
        _timer = null;
        if (videoPlayerController.value.isInitialized) {
          _videoProgressNotifier.value =
              (await videoPlayerController.position)!;
        }
      }
    }
  }

  void _fullscreenFunctionalityListener() {
    // exit fullscreen on end
    if (videoPlayerController.value.duration ==
            videoPlayerController.value.position &&
        !videoPlayerController.value.isPlaying &&
        customVideoPlayerSettings.exitFullscreenOnEnd &&
        _isFullscreen) {
      setFullscreen(false);
    }

    // enter fullscreen on start
    if (videoPlayerController.value.position == Duration.zero &&
        videoPlayerController.value.isPlaying &&
        customVideoPlayerSettings.enterFullscreenOnStart &&
        !_isFullscreen) {
      setFullscreen(true);
    }
  }

  void _playPauseListener() {
    if (videoPlayerController.value.isPlaying) {
      _isPlayingNotifier.value = true;
    } else {
      _isPlayingNotifier.value = false;
    }
  }

  /// call dispose on the dispose method in your parent widget to be sure that every values is disposed
  void dispose() {
    videoPlayerController.removeListener(_videoListeners);
    _timer?.cancel();
    _timer = null;

    _isPlayingNotifier.dispose();
    _videoProgressNotifier.dispose();
  }
}
