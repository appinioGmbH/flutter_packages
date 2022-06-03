import 'package:appinio_video_player/src/controls/video_settings_popup/video_settings_dialog_item.dart';
import 'package:appinio_video_player/src/custom_video_player_controller.dart';
import 'package:flutter/material.dart';

class VideoSettingsPlaybackSpeedDialog extends StatefulWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  const VideoSettingsPlaybackSpeedDialog({
    Key? key,
    required this.customVideoPlayerController,
  }) : super(key: key);

  @override
  State<VideoSettingsPlaybackSpeedDialog> createState() =>
      _VideoSettingsPlaybackSpeedDialogState();
}

class _VideoSettingsPlaybackSpeedDialogState
    extends State<VideoSettingsPlaybackSpeedDialog> {
  final List<double> _playbackSpeeds = [
    0.25,
    0.5,
    0.75,
    1.0,
    1.25,
    1.5,
    1.75,
    2.0,
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: widget
                .customVideoPlayerController
                .customVideoPlayerSettings
                .customVideoPlayerPopupSettings
                .popupDecoration
                .borderRadius ??
            BorderRadius.zero,
      ),
      child: Container(
        padding: widget.customVideoPlayerController.customVideoPlayerSettings
            .customVideoPlayerPopupSettings.popupPadding,
        width: widget.customVideoPlayerController.customVideoPlayerSettings
            .customVideoPlayerPopupSettings.popupWidth,
        decoration: widget.customVideoPlayerController.customVideoPlayerSettings
            .customVideoPlayerPopupSettings.popupDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.customVideoPlayerController.customVideoPlayerSettings
                  .customVideoPlayerPopupSettings.popupPlaybackSpeedTitle,
              style: widget
                  .customVideoPlayerController
                  .customVideoPlayerSettings
                  .customVideoPlayerPopupSettings
                  .popupTitleTextStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                controller: ScrollController(),
                children: [
                  for (double playbackSpeed in _playbackSpeeds)
                    VideoSettingsDialogItem(
                      title: playbackSpeed == 1.0
                          ? "${playbackSpeed}x (${widget.customVideoPlayerController.customVideoPlayerSettings.customVideoPlayerPopupSettings.defaultPlaybackspeedDescription})"
                          : "${playbackSpeed}x",
                      popupSettings: widget
                          .customVideoPlayerController
                          .customVideoPlayerSettings
                          .customVideoPlayerPopupSettings,
                      onPressed: () =>
                          _changeVideoPlayBackSpeed(context, playbackSpeed),
                      selected: widget.customVideoPlayerController
                              .playbackSpeedNotifier.value ==
                          playbackSpeed,
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _changeVideoPlayBackSpeed(
    BuildContext context,
    double playbackSpeed,
  ) {
    widget.customVideoPlayerController.videoPlayerController
        .setPlaybackSpeed(playbackSpeed);
    if (mounted) {
      setState(() {});
    }
  }
}
