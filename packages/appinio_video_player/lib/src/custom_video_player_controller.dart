import 'dart:async';
import 'package:appinio_video_player/src/fullscreen_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:appinio_video_player/src/models/custom_video_player_settings.dart';

/// The extension on the class is able to call private methods
/// only the package can use these methods and not the public beacuse of the hide keyword in the package exports
extension ProtectedCustomVideoPlayerController on CustomVideoPlayerController {
  Future<void> Function(String) get switchVideoSource => _switchVideoSource;

  ValueNotifier<Duration> get videoProgressNotifier => _videoProgressNotifier;

  ValueNotifier<double> get playbackSpeedNotifier => _playbackSpeedNotifier;

  ValueNotifier<bool> get isPlayingNotifier => _isPlayingNotifier;

  bool get isFullscreen => _isFullscreen;

  set updateViewAfterFullscreen(Function updateViewAfterFullscreen) =>
      _updateViewAfterFullscreen = updateViewAfterFullscreen;
}

class CustomVideoPlayerController {
  double _lastVolume = 0.5;
  Duration get getPosition => videoPlayerController.value.position;
  final BuildContext context;
  CachedVideoPlayerController videoPlayerController;
  final CustomVideoPlayerSettings customVideoPlayerSettings;
  final Map<String, CachedVideoPlayerController>? additionalVideoSources;
  final ValueNotifier<bool> areControlsVisible = ValueNotifier<bool>(true);

  Future<void> switchSource(String sourceKey) async {
    assert(additionalVideoSources != null &&
        additionalVideoSources!.containsKey(sourceKey));
    switchVideoSource(sourceKey);
  }

  CustomVideoPlayerController({
    required this.context,
    required this.videoPlayerController,
    this.customVideoPlayerSettings = const CustomVideoPlayerSettings(),
    this.additionalVideoSources,
  }) {
    videoPlayerController.addListener(_videoListeners);
  }

  /// public accessable methods and values for the controller
  final ValueNotifier<bool> playedOnceNotifier = ValueNotifier(false);

  Future<void> setFullscreen(
    bool fullscreen,
  ) async {
    if (kIsWeb) {
      debugPrint(
          "Web doesn't support fullscreen properly. When exiting fullscreen the video will be black. Audio still works.");
    }
    if (fullscreen) {
      await _enterFullscreen();
      _updateViewAfterFullscreen?.call();
    } else {
      await _exitFullscreen();
    }
  }

  /// private fields

  Function? _updateViewAfterFullscreen;

  bool _isFullscreen = false;
  Timer? _timer;
  final ValueNotifier<Duration> _videoProgressNotifier =
      ValueNotifier(Duration.zero);
  final ValueNotifier<double> _playbackSpeedNotifier = ValueNotifier(1.0);
  final ValueNotifier<bool> _isPlayingNotifier = ValueNotifier(false);

  Future<void> _enterFullscreen() async {
    final TransitionRoute<void> route = PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return FullscreenVideoPlayer(
              customVideoPlayerController: this,
            );
          },
        );
      },
    );
    _isFullscreen = true;
    _setOrientationForVideo();
    SystemChrome.setEnabledSystemUIMode(
        customVideoPlayerSettings.systemUIModeInsideFullscreen);
    await Navigator.of(context).push(route);
  }

  Future<void> _exitFullscreen() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await SystemChrome.setEnabledSystemUIMode(
      customVideoPlayerSettings.systemUIModeAfterFullscreen,
      overlays: customVideoPlayerSettings.systemUIOverlaysAfterFullscreen,
    );
    await SystemChrome.setPreferredOrientations(customVideoPlayerSettings
        .deviceOrientationsAfterFullscreen); // reset device orientation values
    _isFullscreen = false;
    Navigator.of(context).pop();
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

  Future<void> _switchVideoSource(String selectedSource) async {
    CachedVideoPlayerController? newSource =
        additionalVideoSources![selectedSource];
    if (newSource != null) {
      Duration _playedDuration = videoPlayerController.value.position;
      double _playbackSpeed = videoPlayerController.value.playbackSpeed;
      bool _wasPlaying = videoPlayerController.value.isPlaying;
      videoPlayerController.pause();
      videoPlayerController.removeListener(_videoListeners);
      videoPlayerController = newSource;
      await videoPlayerController.initialize();
      videoPlayerController.addListener(
          _videoListeners); // add listeners to new video controller
      if (isFullscreen) {
        _setOrientationForVideo(); // if video changed completely
      }
      await videoPlayerController.seekTo(_playedDuration);
      if (Theme.of(context).platform != TargetPlatform.iOS) {
        await videoPlayerController.setPlaybackSpeed(_playbackSpeed);
      } else {
        await videoPlayerController.setPlaybackSpeed(
            1); // resetting to 1 because its not working on iOS. open issue on github
      }
      if (_wasPlaying) {
        await videoPlayerController.play();
      }
      _updateViewAfterFullscreen?.call();
    }
  }

  /// Listeners
  void _videoListeners() {
    _fluidVideoProgressListener();
    _fullscreenFunctionalityListener();
    _playPauseListener();
    _playbackSpeedListener();
    _onVideoEndListener();
  }

  /// used to make progress more fluid
  Future<void> _fluidVideoProgressListener() async {
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

  /// save that the video is played once
  void _onVideoEndListener() {
    if (videoPlayerController.value.position > Duration.zero) {
      if (videoPlayerController.value.duration ==
          videoPlayerController.value.position) {
        playedOnceNotifier.value = true;
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

  void _playbackSpeedListener() {
    _playbackSpeedNotifier.value = videoPlayerController.value.playbackSpeed;
  }

  /// call dispose on the dispose method in your parent widget to be sure that every values is disposed
  void dispose() {
    videoPlayerController.removeListener(_videoListeners);
    _timer?.cancel();
    _timer = null;

    _isPlayingNotifier.dispose();
    _videoProgressNotifier.dispose();
    _playbackSpeedNotifier.dispose();
    videoPlayerController.dispose();
    if (additionalVideoSources != null) {
      if (additionalVideoSources!.isNotEmpty) {
        for (MapEntry<String, CachedVideoPlayerController> videoSource
            in additionalVideoSources!.entries) {
          videoSource.value.dispose();
        }
      }
    }
  }

  void mute() {
    _lastVolume = videoPlayerController.value.volume;
    videoPlayerController.setVolume(0);
  }

  void unMute() {
    videoPlayerController.setVolume(_lastVolume);
  }
}
