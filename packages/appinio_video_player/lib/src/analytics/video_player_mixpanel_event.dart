/// Types of events that the video package exposes for tracking.
enum VideoPlayerMixpanelEventType {
  videoControllerInvalidState,
  videoPlayerEnterFullscreen,
  videoPlayerExitFullscreen,
  switchVideoSource,
  videoControllerInitializeVideo,
  pauseVideo,
  playVideo,
  videoPlayerCleanupSurface,
  videoPlayerCleanupSeek,
  videoListeners,
  videoPlayerErrorDetected,
  videoErrorListener,
  videoProgress,
  videoEnd,
  fullscreenFunctionalityError,
  playPauseListenerError,
  playbackSpeedListenerError,
  disposalError,
  disposeAlreadyInProgress,
  enterFullscreenSuccess,
  exitFullscreenSuccess,
}

/// Payload describing a failure that should be tracked.
class VideoPlayerMixpanelEvent {
  /// The type of failure that occurred.
  final VideoPlayerMixpanelEventType type;

  /// The original error object if available.
  final Object? error;

  /// The stack trace associated with the error.
  final StackTrace? stackTrace;

  /// A short human readable message that can be surfaced to analytics.
  final String message;

  /// Additional properties that clients can merge with the default payload.
  final Map<String, dynamic> properties;

  const VideoPlayerMixpanelEvent({
    required this.type,
    required this.message,
    this.error,
    this.stackTrace,
    Map<String, dynamic>? properties,
  }) : properties = properties ?? const {};

  String get eventName => type.name;

  /// A helper payload that merges the default bookkeeping fields with the
  /// additional [properties].
  Map<String, dynamic> get payload {
    return <String, dynamic>{
      'message': message,
      if (error != null) 'error': error.toString(),
      if (stackTrace != null) 'stackTrace': stackTrace.toString(),
      ...properties,
    };
  }
}

/// Callback signature that clients can pass to receive failure tracking events.
typedef VideoPlayerMixpanelEventCallback = void Function(
  VideoPlayerMixpanelEvent event,
);

