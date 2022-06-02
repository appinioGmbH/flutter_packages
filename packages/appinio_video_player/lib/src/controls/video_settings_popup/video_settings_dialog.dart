import 'package:appinio_video_player/src/controls/video_settings_popup/video_settings_dialog_item.dart';
import 'package:appinio_video_player/src/controls/video_settings_popup/video_settings_playback_speed_dialog.dart';
import 'package:appinio_video_player/src/controls/video_settings_popup/video_settings_quality_dialog.dart';
import 'package:appinio_video_player/src/models/custom_video_player_popup_settings.dart';
import 'package:flutter/material.dart';

import 'package:appinio_video_player/appinio_video_player.dart';

class VideoSettingsDialog extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  const VideoSettingsDialog({
    Key? key,
    required this.customVideoPlayerController,
  }) : super(key: key);

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
                  .customVideoPlayerPopupSettings.popupTitle,
              style: customVideoPlayerController.customVideoPlayerSettings
                  .customVideoPlayerPopupSettings.popupTitleTextStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            Column(
              children: [
                if (customVideoPlayerController.additionalVideoSources != null)
                  if (customVideoPlayerController
                      .additionalVideoSources!.isNotEmpty)
                    VideoSettingsDialogItem(
                      title: customVideoPlayerController
                          .customVideoPlayerSettings
                          .customVideoPlayerPopupSettings
                          .popupQualityTitle,
                      popupSettings: customVideoPlayerController
                          .customVideoPlayerSettings
                          .customVideoPlayerPopupSettings,
                      onPressed: () => _openSubSettingsDialog(
                        context: context,
                        isQuality: true,
                      ),
                    ),
                VideoSettingsDialogItem(
                  title: customVideoPlayerController.customVideoPlayerSettings
                      .customVideoPlayerPopupSettings.popupPlaybackSpeedTitle,
                  popupSettings: customVideoPlayerController
                      .customVideoPlayerSettings.customVideoPlayerPopupSettings,
                  onPressed: () => _openSubSettingsDialog(
                    context: context,
                    isQuality: false,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _openSubSettingsDialog({
    required BuildContext context,
    required bool isQuality,
  }) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) => isQuality
          ? VideoSettingsQualityDialog(
              customVideoPlayerController: customVideoPlayerController,
            )
          : VideoSettingsPlaybackSpeedDialog(
              customVideoPlayerController: customVideoPlayerController,
            ),
    );
  }
}
