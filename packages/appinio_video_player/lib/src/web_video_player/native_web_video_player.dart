import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;

class NativeWebVideoPlayer extends StatefulWidget {
  final CustomVideoPlayerWebController customVideoPlayerWebController;

  NativeWebVideoPlayer({
    required this.customVideoPlayerWebController,
  }) : super(key: customVideoPlayerWebController.webVideoPlayerSettings.key);

  @override
  _NativeWebVideoPlayerState createState() => _NativeWebVideoPlayerState();
}

class _NativeWebVideoPlayerState extends State<NativeWebVideoPlayer> {
  final html.VideoElement _video = html.VideoElement();
  late CustomVideoPlayerWebSettings _videoPlayerSettings;
  num _videoPosition = 0;

  @override
  void initState() {
    super.initState();
    _videoPlayerSettings =
        widget.customVideoPlayerWebController.webVideoPlayerSettings;
    _initVideoElement();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: _videoPlayerSettings.aspectRatio != null
          ? AspectRatio(
              aspectRatio: _videoPlayerSettings.aspectRatio!,
              child: HtmlElementView(
                viewType: _videoPlayerSettings.src,
              ),
            )
          : HtmlElementView(
              viewType: _videoPlayerSettings.src,
            ),
    );
  }

  void _initVideoElement() {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(_videoPlayerSettings.src,
        (int viewId) {
      _video.src =
          _videoPlayerSettings.src + '#t=${_videoPlayerSettings.startAt}';
      _video.autoplay = _videoPlayerSettings.autoplay;
      _video.controls = _videoPlayerSettings.enableControls;
      if (_videoPlayerSettings.thumbnailPath != null) {
        _video.poster = _videoPlayerSettings.thumbnailPath!;
      }
      _video.setAttribute(
        'disablePictureInPicture',
        widget.customVideoPlayerWebController.webVideoPlayerSettings
            .disablePictureInPicture,
      );
      if (_videoPlayerSettings.hideDownloadButton) {
        _video.setAttribute('controlsList', 'nodownload');
      }

      if (_videoPlayerSettings.backgroundColor != null) {
        _video.style.backgroundColor = _videoPlayerSettings.backgroundColor;
      }

      _video.style.width = '100%';
      _video.style.height = '100%';
      _video.style.border = 'none';
      _video.setAttribute('playsInline', true);

      // listeners
      _video.onTimeUpdate.listen((event) {
        if (!_video.seeking) {
          _videoPosition = _video.currentTime;
        }
      });

      _video.onEnded.listen((event) {
        if (_videoPlayerSettings.exitFullscreenOnEnd) {
          _video.exitFullscreen();
        }
      });

      _video.onPlay.listen((event) {
        widget.customVideoPlayerWebController.isPlaying.value = true;
        if (_videoPlayerSettings.enterFullscreenOnStart &&
            _videoPosition == 0) {
          _video.requestFullscreen();
        }
      });

      _video.onPause.listen((event) {
        widget.customVideoPlayerWebController.isPlaying.value = false;
      });

      _video.onSeeking.listen((event) {
        if (_videoPlayerSettings.preventSeeking) {
          num delta = _video.currentTime - _videoPosition;
          if (delta.abs() > 0.01) {
            _video.currentTime = _videoPosition;
            _video.pause();
          }
        }
      });

      //set controller methods
      widget.customVideoPlayerWebController.play = _play;
      widget.customVideoPlayerWebController.pause = _pause;
      widget.customVideoPlayerWebController.setFullscreen = _setFullscreen;
      widget.customVideoPlayerWebController.seekTo = _seekTo;
      widget.customVideoPlayerWebController.mute = _mute;
      widget.customVideoPlayerWebController.unmute = _unmute;
      widget.customVideoPlayerWebController.setPlaybackSpeed =
          _setPlaybackSpeed;

      return _video;
    });
  }

  // controller methods
  void _play() {
    _video.play();
  }

  void _pause() {
    _video.pause();
  }

  void _setFullscreen(bool fullscreen) {
    if (fullscreen) {
      _video.enterFullscreen();
    } else {
      _video.exitFullscreen();
    }
  }

  void _seekTo(double position) {
    _video.currentTime = position;
  }

  void _mute() {
    _video.muted = true;
  }

  void _unmute() {
    _video.muted = false;
  }

  void _setPlaybackSpeed(double speed) {
    _video.playbackRate = speed;
  }
}
