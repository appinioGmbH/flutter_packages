import 'dart:async';
import 'package:appinio_video_player/src/fullscreen_video_player.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:appinio_video_player/src/models/custom_video_player_settings.dart';
import 'package:appinio_video_player/src/helpers/platform_helper.dart';

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
  final BuildContext context;
  VideoPlayerController videoPlayerController;
  final CustomVideoPlayerSettings customVideoPlayerSettings;
  final Map<String, VideoPlayerController>? additionalVideoSources;
  final ValueNotifier<bool> areControlsVisible = ValueNotifier<bool>(true);
  final PlatformHelper _platformHelper = const PlatformHelper();

  bool _isDisposed = false;
  bool _isDisposing = false;
  bool _isExitingFullscreen = false;

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

  Future<void> setFullscreen(bool fullscreen) async {
    if (_isDisposed || _isDisposing) {
      debugPrint('Cannot set fullscreen: controller is disposed');
      return;
    }

    if (_platformHelper.isWeb) {
      debugPrint(
        "Web doesn't support fullscreen properly. When exiting fullscreen the video will be black. Audio still works.",
      );
    }
    if (fullscreen) {
      await _enterFullscreen();
      _updateViewAfterFullscreen?.call();
    } else {
      await _exitFullscreen();
    }
  }

  /// Check if controller is in a valid state for operations
  bool get isControllerValid => !_isDisposed && !_isDisposing;

  /// Check if currently exiting fullscreen
  bool get isExitingFullscreen => _isExitingFullscreen;

  /// Check if video player is in a valid state for operations
  bool get _isVideoPlayerValid =>
      videoPlayerController.value.isInitialized && 
      !videoPlayerController.value.hasError;

  /// private fields

  Function? _updateViewAfterFullscreen;

  bool _isFullscreen = false;
  Timer? _timer;
  final ValueNotifier<Duration> _videoProgressNotifier = ValueNotifier(
    Duration.zero,
  );
  final ValueNotifier<double> _playbackSpeedNotifier = ValueNotifier(1.0);
  final ValueNotifier<bool> _isPlayingNotifier = ValueNotifier(false);

  Future<void> _enterFullscreen() async {
    try {
      final TransitionRoute<void> route = PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? child) {
              return FullscreenVideoPlayer(customVideoPlayerController: this);
            },
          );
        },
      );

      _isFullscreen = true;
      _setOrientationForVideo();
      SystemChrome.setEnabledSystemUIMode(
        customVideoPlayerSettings.systemUIModeInsideFullscreen,
      );

      if (context.mounted) {
        await Navigator.of(context).push(route);
      }
    } catch (e) {
      debugPrint('Error entering fullscreen: $e');
      _isFullscreen = false; // Reset state on error
    }
  }

  Future<void> _exitFullscreen() async {
    if (_isExitingFullscreen) {
      debugPrint('Already exiting fullscreen, skipping duplicate call');
      return;
    }
    _isExitingFullscreen = true;
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      await SystemChrome.setEnabledSystemUIMode(
        customVideoPlayerSettings.systemUIModeAfterFullscreen,
        overlays: customVideoPlayerSettings.systemUIOverlaysAfterFullscreen,
      );
      await SystemChrome.setPreferredOrientations(
        customVideoPlayerSettings.deviceOrientationsAfterFullscreen,
      ); // reset device orientation values
      _isFullscreen = false;

      if (context.mounted) {
        final navigator = Navigator.of(context);
        if (navigator.canPop()) {
          navigator.pop();
        } else {
          debugPrint('Cannot pop from fullscreen - no route to pop');
        }
      }
    } catch (e) {
      debugPrint('Error exiting fullscreen: $e');
      _isFullscreen = false; // Ensure state is reset even on error
    } finally {
      _isExitingFullscreen = false;
    }
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
    try {
      VideoPlayerController? newSource =
          additionalVideoSources![selectedSource];

      if (newSource != null) {
        Duration _playedDuration = videoPlayerController.value.position;
        double _playbackSpeed = videoPlayerController.value.playbackSpeed;
        bool _wasPlaying = videoPlayerController.value.isPlaying;
        await _safelyPauseVideo();
        videoPlayerController.removeListener(_videoListeners);
        videoPlayerController = newSource;
        await _safelyInitializeVideo();
        videoPlayerController.addListener(
          _videoListeners,
        ); // add listeners to new video controller
        if (isFullscreen) {
          _setOrientationForVideo(); // if video changed completely
        }
        await videoPlayerController.seekTo(_playedDuration);
        if (_platformHelper.supportsPlaybackSpeedChange(context)) {
          await videoPlayerController.setPlaybackSpeed(_playbackSpeed);
        } else {
          await videoPlayerController.setPlaybackSpeed(
            1,
          ); // resetting to 1 because its not working on iOS. open issue on github
        }

        if (_wasPlaying) {
          await _safelyPlayVideo();
        }
        _updateViewAfterFullscreen?.call();
      }
    } catch (e) {
      debugPrint('Error switching video source: $e');
    }
  }

  Future<void> _safelyInitializeVideo() async {
    if (_isDisposed || _isDisposing) {
      debugPrint('Cannot initialize video: controller is in invalid state');
      return;
    }

    try {
      await videoPlayerController.initialize();
    } catch (e) {
      debugPrint('Video initialization failed: $e');
    }
  }

  Future<void> _safelyPauseVideo() async {
    if (_isDisposed || _isDisposing) {
      debugPrint('Cannot pause video: controller is in invalid state');
      return;
    }

    try {
      if (_isVideoPlayerValid) {
        await videoPlayerController.pause();
      }
    } catch (e) {
      debugPrint('Error pausing video: $e');
    }
  }

  Future<void> _safelyPlayVideo() async {
    if (_isDisposed || _isDisposing) {
      debugPrint('Cannot play video: controller is in invalid state');
      return;
    }

    try {
      if (_isVideoPlayerValid) {
        await videoPlayerController.play();
      }
    } catch (e) {
      debugPrint('Error playing video: $e');
    }
  }

  Future<void> _safelyCleanupSurface() async {
    try {
      if (videoPlayerController.value.isInitialized) {
        await _safelyPauseVideo();
        await Future.delayed(const Duration(milliseconds: 200));
        try {
          await videoPlayerController.seekTo(Duration.zero);
        } catch (e) {
          debugPrint('Error seeking to beginning during cleanup: $e');
        }
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } catch (e) {
      debugPrint('Error during surface cleanup: $e');
    }
  }

  /// Listeners
  void _videoListeners() {
    _checkDisposalStatus();
    try {
      _fluidVideoProgressListener();
      _fullscreenFunctionalityListener();
      _playPauseListener();
      _playbackSpeedListener();
      _onVideoEndListener();
      _onVideoErrorListener();
    } catch (e) {
      debugPrint('Error in video listeners: $e');
    }
  }

  /// Handle video player errors
  void _onVideoErrorListener() {
    try {
      if (videoPlayerController.value.hasError) {
        debugPrint(
          'Video player error detected: ${videoPlayerController.value.errorDescription}',
        );
        // Cancel any ongoing timers
        _timer?.cancel();
        _timer = null;
        // Update playing state
        _isPlayingNotifier.value = false;
      }
    } catch (e) {
      debugPrint('Error in video error listener: $e');
    }
  }

  /// used to make progress more fluid
  Future<void> _fluidVideoProgressListener() async {
    _checkDisposalStatus();

    if (videoPlayerController.value.isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 100), (
        Timer timer,
      ) async {
        try {
          if (_isDisposed || _isDisposing) {
            timer.cancel();
            return;
          }

          if (!videoPlayerController.value.isInitialized) {
            timer.cancel();
            return;
          }

          if (videoPlayerController.value.hasError) {
            debugPrint('Video player has error, cancelling timer');
            timer.cancel();
            return;
          }

          if (videoPlayerController.value.isInitialized) {
            _videoProgressNotifier.value =
                await videoPlayerController.position ??
                _videoProgressNotifier.value;
          }
        } catch (e) {
          debugPrint('Error getting video position: $e');
          timer.cancel();
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
    _checkDisposalStatus();

    try {
      if (videoPlayerController.value.position > Duration.zero) {
        if (videoPlayerController.value.duration ==
            videoPlayerController.value.position) {
          playedOnceNotifier.value = true;
        }
      }
    } catch (e) {
      debugPrint('Error in video end listener: $e');
    }
  }

  void _fullscreenFunctionalityListener() {
    _checkDisposalStatus();

    try {
      if (videoPlayerController.value.duration ==
              videoPlayerController.value.position &&
          !videoPlayerController.value.isPlaying &&
          customVideoPlayerSettings.exitFullscreenOnEnd &&
          _isFullscreen &&
          !_isExitingFullscreen) {
        _exitFullscreen();
      }

      // enter fullscreen on start
      if (videoPlayerController.value.position == Duration.zero &&
          videoPlayerController.value.isPlaying &&
          customVideoPlayerSettings.enterFullscreenOnStart &&
          !_isFullscreen) {
        setFullscreen(true);
      }
    } catch (e) {
      debugPrint('Error in fullscreen functionality listener: $e');
    }
  }

  void _checkDisposalStatus() {
    if (_isDisposed || _isDisposing) {
      return;
    }
  }

  void _playPauseListener() {
    _checkDisposalStatus();

    try {
      if (videoPlayerController.value.isPlaying) {
        _isPlayingNotifier.value = true;
      } else {
        _isPlayingNotifier.value = false;
      }
    } catch (e) {
      debugPrint('Error in play/pause listener: $e');
    }
  }

  void _playbackSpeedListener() {
    if (_isDisposed || _isDisposing) {
      return;
    }

    try {
      _playbackSpeedNotifier.value = videoPlayerController.value.playbackSpeed;
    } catch (e) {
      debugPrint('Error in playback speed listener: $e');
    }
  }

  /// call dispose on the dispose method in your parent widget to be sure that every values is disposed
  Future<void> dispose() async {
    if (_isDisposed || _isDisposing) {
      debugPrint('Video player already disposed or disposing');
      return;
    }
    _isDisposing = true;
    try {
      _timer?.cancel();
      _timer = null;
      await _safelyCleanupSurface();
      await Future.delayed(const Duration(milliseconds: 100));
      if (videoPlayerController.value.isInitialized) {
        videoPlayerController.removeListener(_videoListeners);
      }
      _isPlayingNotifier.dispose();
      _videoProgressNotifier.dispose();
      _playbackSpeedNotifier.dispose();
      areControlsVisible.dispose();
      playedOnceNotifier.dispose();
      if (videoPlayerController.value.isInitialized) {
        videoPlayerController.dispose();
      }

      if (additionalVideoSources != null &&
          additionalVideoSources!.isNotEmpty) {
        for (MapEntry<String, VideoPlayerController> videoSource
            in additionalVideoSources!.entries) {
          if (videoSource.value.value.isInitialized) {
            videoSource.value.dispose();
          }
        }
        additionalVideoSources!.clear();
      }

      _isDisposed = true;
      debugPrint('Video player disposal completed');
    } catch (e) {
      debugPrint('Error during dispose: $e');
    } finally {
      _isDisposing = false;
    }
  }
}
