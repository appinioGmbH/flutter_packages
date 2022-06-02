import 'package:appinio_video_player/src/controls/video_settings_popup/video_settings_dialog_item.dart';
import 'package:appinio_video_player/src/custom_video_player_controller_base.dart';
import 'package:flutter/material.dart';
import 'package:appinio_video_player/src/custom_video_player_controller.dart';

class VideoSettingsPlaybackSpeedDialog extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  const VideoSettingsPlaybackSpeedDialog({
    Key? key,
    required this.customVideoPlayerController,
  }) : super(key: key);

  static final List<double> playbackSpeeds = [
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
        borderRadius: customVideoPlayerController.customVideoPlayerSettings
                .customVideoPlayerPopupSettings.popupDecoration.borderRadius ??
            BorderRadius.zero,
      ),
      child: Container(
        padding: customVideoPlayerController.customVideoPlayerSettings
            .customVideoPlayerPopupSettings.popupPadding,
        width: customVideoPlayerController.customVideoPlayerSettings
            .customVideoPlayerPopupSettings.popupWidth,
        decoration: customVideoPlayerController.customVideoPlayerSettings
            .customVideoPlayerPopupSettings.popupDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              customVideoPlayerController.customVideoPlayerSettings
                  .customVideoPlayerPopupSettings.popupPlaybackSpeedTitle,
              style: customVideoPlayerController.customVideoPlayerSettings
                  .customVideoPlayerPopupSettings.popupTitleTextStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                controller: ScrollController(),
                children: [
                  for (double playbackSpeed in playbackSpeeds)
                    VideoSettingsDialogItem(
                      title: playbackSpeed == 1.0
                          ? "${playbackSpeed}x (${customVideoPlayerController.customVideoPlayerSettings.customVideoPlayerPopupSettings.defaultPlaybackspeedDescription})"
                          : "${playbackSpeed}x",
                      popupSettings: customVideoPlayerController
                          .customVideoPlayerSettings
                          .customVideoPlayerPopupSettings,
                      onPressed: () =>
                          _changeVideoPlayBackSpeed(context, playbackSpeed),
                      selected: customVideoPlayerController
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
    customVideoPlayerController.videoPlayerController
        .setPlaybackSpeed(playbackSpeed);
    Navigator.pop(context);
  }
}
