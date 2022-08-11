import 'package:appinio_video_player/src/controls/video_settings_popup/video_settings_dialog_item.dart';
import 'package:appinio_video_player/src/controls/video_settings_popup/video_settings_playback_speed_dialog.dart';
import 'package:appinio_video_player/src/controls/video_settings_popup/video_settings_quality_dialog.dart';
import 'package:appinio_video_player/src/custom_video_player_controller.dart';
import 'package:flutter/material.dart';

import 'package:appinio_video_player/appinio_video_player.dart';

class VideoSettingsDialog extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  final Function updateViewOnClose;
  const VideoSettingsDialog({
    Key? key,
    required this.customVideoPlayerController,
    required this.updateViewOnClose,
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
  }) async {
    Navigator.of(context).pop(); //close old popup
    await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "custom_video_player_controls_barrier2",
        pageBuilder: (context, _, __) {
          return isQuality
              ? VideoSettingsQualityDialog(
                  customVideoPlayerController: customVideoPlayerController,
                  updateView: updateViewOnClose,
                )
              : VideoSettingsPlaybackSpeedDialog(
                  customVideoPlayerController: customVideoPlayerController,
                );
        });
    updateViewOnClose();
  }
}
