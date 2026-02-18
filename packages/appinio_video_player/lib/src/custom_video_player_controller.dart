import 'dart:async';
import 'package:appinio_video_player/src/fullscreen_video_player.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:appinio_video_player/src/models/custom_video_player_settings.dart';
import 'package:appinio_video_player/src/helpers/platform_helper.dart';
import 'package:appinio_video_player/src/analytics/video_player_mixpanel_event.dart';

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
  final VideoPlayerMixpanelEventCallback? mixpanelEventCallback;
  final String? contextId;
  final ValueNotifier<bool> areControlsVisible = ValueNotifier<bool>(true);
  final PlatformHelper _platformHelper = const PlatformHelper();

  bool _isDisposed = false;
  bool _isDisposing = false;
  bool _isExitingFullscreen = false;
  bool _isAttemptingFallback = false;

  /// Prevents overlapping position updates in the progress timer callback (avoids main-thread load on slow devices).
  bool _progressUpdateInProgress = false;

  /// Tracks which additional source key is currently active; null when using the main [videoPlayerController].
  String? _currentSourceKey;

  CustomVideoPlayerController({
    required this.context,
    required this.videoPlayerController,
    this.customVideoPlayerSettings = const CustomVideoPlayerSettings(),
    this.additionalVideoSources,
    this.mixpanelEventCallback,
    this.contextId,
  }) {
    videoPlayerController.addListener(_videoListeners);
  }

  /// public accessable methods and values for the controller
  final ValueNotifier<bool> playedOnceNotifier = ValueNotifier(false);

  Future<void> setFullscreen(bool fullscreen) async {
    if (_isDisposed || _isDisposing) {
      const message = 'Cannot set fullscreen: controller is disposed';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.videoControllerInvalidState,
        message,
      );
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

  void _trackMixpanelEvent(
    VideoPlayerMixpanelEventType type,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? properties,
  }) {
    final callback = mixpanelEventCallback;
    if (callback == null) {
      return;
    }

    callback(
      VideoPlayerMixpanelEvent(
        type: type,
        message: message,
        error: error,
        stackTrace: stackTrace,
        properties: {
          if (contextId != null) 'id': contextId,
          ...?properties,
        },
      ),
    );
  }

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
        const successMessage = 'Entered fullscreen successfully';
        _trackMixpanelEvent(
          VideoPlayerMixpanelEventType.enterFullscreenSuccess,
          successMessage,
        );
        await Navigator.of(context).push(route);
      }
    } catch (e, stackTrace) {
      final message = 'Error entering fullscreen: $e';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.videoPlayerEnterFullscreen,
        message,
        error: e,
        stackTrace: stackTrace,
      );
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
          const successMessage = 'Exited fullscreen successfully';
          _trackMixpanelEvent(
            VideoPlayerMixpanelEventType.exitFullscreenSuccess,
            successMessage,
          );
        } else {
          const message = 'Cannot pop from fullscreen - no route to pop';
          debugPrint(message);
          _trackMixpanelEvent(
            VideoPlayerMixpanelEventType.videoPlayerExitFullscreen,
            message,
          );
        }
      }
    } catch (e, stackTrace) {
      final message = 'Error exiting fullscreen: $e';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.videoPlayerExitFullscreen,
        message,
        error: e,
        stackTrace: stackTrace,
      );
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
        _currentSourceKey = selectedSource;
        _updateViewAfterFullscreen?.call();
      }
    } catch (e, stackTrace) {
      final message = 'Error switching video source: $e';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.switchVideoSource,
        message,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _safelyInitializeVideo() async {
    if (_isDisposed || _isDisposing) {
      const message = 'Cannot initialize video: controller is in invalid state';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.videoControllerInvalidState,
        message,
      );
      return;
    }

    try {
      await videoPlayerController.initialize();
    } catch (e, stackTrace) {
      final message = 'Video initialization failed: $e';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.videoControllerInitializeVideo,
        message,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _safelyPauseVideo() async {
    if (_isDisposed || _isDisposing) {
      const message = 'Cannot pause video: controller is in invalid state';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.videoControllerInvalidState,
        message,
      );
      return;
    }

    try {
      if (_isVideoPlayerValid) {
        await videoPlayerController.pause();
      }
    } catch (e, stackTrace) {
      final message = 'Error pausing video: $e';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.pauseVideo,
        message,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _safelyPlayVideo() async {
    if (_isDisposed || _isDisposing) {
      const message = 'Cannot play video: controller is in invalid state';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.videoControllerInvalidState,
        message,
      );
      return;
    }

    try {
      if (_isVideoPlayerValid) {
        await videoPlayerController.play();
      }
    } catch (e, stackTrace) {
      final message = 'Error playing video: $e';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.playVideo,
        message,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _safelyCleanupSurface() async {
    try {
      if (videoPlayerController.value.isInitialized) {
        await _safelyPauseVideo();
        try {
          await videoPlayerController.seekTo(Duration.zero);
        } catch (e, stackTrace) {
          final message = 'Error seeking to beginning during cleanup: $e';
          debugPrint(message);
          _trackMixpanelEvent(
            VideoPlayerMixpanelEventType.videoPlayerCleanupSeek,
            message,
            error: e,
            stackTrace: stackTrace,
          );
        }
      }
    } catch (e, stackTrace) {
      final message = 'Error during surface cleanup: $e';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.videoPlayerCleanupSurface,
        message,
        error: e,
        stackTrace: stackTrace,
      );
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
    } catch (e, stackTrace) {
      final message = 'Error in video listeners: $e';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.videoListeners,
        message,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Returns true if [description] looks like a codec/renderer error (e.g. MediaCodecVideoRenderer on Android).
  bool _isCodecOrRendererError(String description) {
    final lower = description.toLowerCase();
    return lower.contains('mediacodec') ||
        lower.contains('mediacodecvideorenderer') ||
        lower.contains('had error');
  }

  /// Returns additional source keys sorted by quality ascending (lowest first),
  /// using numbers parsed from keys (e.g. 240p, 480p).
  List<String> _getOrderedQualityKeys() {
    final sources = additionalVideoSources;
    if (sources == null || sources.isEmpty) return [];
    final keys = sources.keys.toList();
    keys.sort((a, b) {
      final aNum = RegExp(r'(\d+)').firstMatch(a);
      final bNum = RegExp(r'(\d+)').firstMatch(b);
      final aVal = aNum != null ? (int.tryParse(aNum.group(1)!) ?? 9999) : 9999;
      final bVal = bNum != null ? (int.tryParse(bNum.group(1)!) ?? 9999) : 9999;
      return aVal.compareTo(bVal);
    });
    return keys;
  }

  /// Attempts to switch to a lower quality source when a codec/renderer error is detected.
  Future<void> _attemptFallbackToLowerQuality(String errorDescription) async {
    if (_isDisposed || _isDisposing || _isAttemptingFallback) return;
    final sources = additionalVideoSources;
    if (sources == null || sources.isEmpty) return;

    final orderedKeys = _getOrderedQualityKeys();
    if (orderedKeys.isEmpty) return;

    final String? fallbackKey;
    if (_currentSourceKey == null) {
      fallbackKey = orderedKeys.first;
    } else {
      final index = orderedKeys.indexOf(_currentSourceKey!);
      if (index <= 0) return;
      fallbackKey = orderedKeys[index - 1];
    }

    if (fallbackKey == null || sources[fallbackKey] == null) return;

    _isAttemptingFallback = true;
    try {
      await _switchVideoSource(fallbackKey);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.fallbackToLowerQualityDueToError,
        'Switched to lower quality due to codec/renderer error',
        properties: {
          'fallbackTo': fallbackKey,
          'previousError': errorDescription,
        },
      );
      debugPrint(
        'Fallback to lower quality: switched to "$fallbackKey" after error: $errorDescription',
      );
    } finally {
      _isAttemptingFallback = false;
    }
  }

  /// Handle video player errors
  void _onVideoErrorListener() {
    try {
      if (videoPlayerController.value.hasError) {
        final description =
            videoPlayerController.value.errorDescription ?? 'Unknown error';
        final message = 'Video player error detected: $description';
        debugPrint(message);
        _trackMixpanelEvent(
          VideoPlayerMixpanelEventType.videoPlayerErrorDetected,
          message,
          properties: {'errorDescription': description},
        );
        // Cancel any ongoing timers
        _timer?.cancel();
        _timer = null;
        // Update playing state
        _isPlayingNotifier.value = false;

        // Attempt automatic fallback to lower quality on codec/renderer errors
        if (_isCodecOrRendererError(description)) {
          Future.microtask(() => _attemptFallbackToLowerQuality(description));
        }
      }
    } catch (e, stackTrace) {
      final message = 'Error in video error listener: $e';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.videoErrorListener,
        message,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Used to make progress more fluid. Only one timer is created while playing; overlapping position fetches are skipped to avoid freezing on slow devices.
  Future<void> _fluidVideoProgressListener() async {
    _checkDisposalStatus();

    if (videoPlayerController.value.isPlaying) {
      // Avoid creating multiple timers: _videoListeners() runs on every video value change, so without this we would leak a new timer each time and freeze the app.
      if (_timer != null) return;

      final interval = customVideoPlayerSettings.progressUpdateInterval;
      _timer = Timer.periodic(interval, (
        Timer timer,
      ) async {
        if (_isDisposed || _isDisposing) {
          timer.cancel();
          _timer = null;
          return;
        }
        if (!videoPlayerController.value.isInitialized ||
            videoPlayerController.value.hasError) {
          timer.cancel();
          _timer = null;
          return;
        }
        if (_progressUpdateInProgress) return;

        _progressUpdateInProgress = true;
        try {
          final position = await videoPlayerController.position;
          if (_isDisposed || _isDisposing) return;
          if (videoPlayerController.value.isInitialized &&
              !videoPlayerController.value.hasError) {
            _videoProgressNotifier.value =
                position ?? _videoProgressNotifier.value;
          }
        } catch (e, stackTrace) {
          if (!_isDisposed && !_isDisposing) {
            final message = 'Error getting video position: $e';
            debugPrint(message);
            _trackMixpanelEvent(
              VideoPlayerMixpanelEventType.videoProgress,
              message,
              error: e,
              stackTrace: stackTrace,
            );
          }
          timer.cancel();
          _timer = null;
        } finally {
          _progressUpdateInProgress = false;
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
    } catch (e, stackTrace) {
      final message = 'Error in video end listener: $e';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.videoEnd,
        message,
        error: e,
        stackTrace: stackTrace,
      );
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
    } catch (e, stackTrace) {
      final message = 'Error in fullscreen functionality listener: $e';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.fullscreenFunctionalityError,
        message,
        error: e,
        stackTrace: stackTrace,
      );
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
    } catch (e, stackTrace) {
      final message = 'Error in play/pause listener: $e';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.playPauseListenerError,
        message,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _playbackSpeedListener() {
    if (_isDisposed || _isDisposing) {
      return;
    }

    try {
      _playbackSpeedNotifier.value = videoPlayerController.value.playbackSpeed;
    } catch (e, stackTrace) {
      final message = 'Error in playback speed listener: $e';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.playbackSpeedListenerError,
        message,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// call dispose on the dispose method in your parent widget to be sure that every values is disposed
  Future<void> dispose() async {
    if (_isDisposed || _isDisposing) {
      const message = 'Video player already disposed or disposing';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.disposeAlreadyInProgress,
        message,
      );
      return;
    }
    _isDisposing = true;
    try {
      _timer?.cancel();
      _timer = null;
      await _safelyCleanupSurface();
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
    } catch (e, stackTrace) {
      final message = 'Error during dispose: $e';
      debugPrint(message);
      _trackMixpanelEvent(
        VideoPlayerMixpanelEventType.disposalError,
        message,
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      _isDisposing = false;
    }
  }
}
