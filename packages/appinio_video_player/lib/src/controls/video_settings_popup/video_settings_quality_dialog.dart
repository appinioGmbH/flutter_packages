import 'package:appinio_video_player/src/controls/video_settings_popup/video_settings_dialog_item.dart';
import 'package:appinio_video_player/src/custom_video_player_controller_base.dart';
import 'package:flutter/material.dart';

import 'package:appinio_video_player/appinio_video_player.dart';

class VideoSettingsQualityDialog extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  const VideoSettingsQualityDialog({
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
                  .customVideoPlayerPopupSettings.popupQualityTitle,
              style: customVideoPlayerController.customVideoPlayerSettings
                  .customVideoPlayerPopupSettings.popupTitleTextStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            Flexible(
              child: ListView(
                controller: ScrollController(),
                shrinkWrap: true,
                children: [
                  for (MapEntry<String, VideoPlayerController> videoSource
                      in customVideoPlayerController
                          .additionalVideoSources!.entries)
                    VideoSettingsDialogItem(
                      title: videoSource.key,
                      popupSettings: customVideoPlayerController
                          .customVideoPlayerSettings
                          .customVideoPlayerPopupSettings,
                      onPressed: () => _changeVideoQuality(
                        context: context,
                        selectedSource: videoSource.key,
                      ),
                      selected:
                          _getCurrentVideoPlayerSource() == videoSource.key,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentVideoPlayerSource() {
    return customVideoPlayerController.additionalVideoSources!.entries
        .toList()
        .firstWhere((element) =>
            element.value == customVideoPlayerController.videoPlayerController)
        .key;
  }

  void _changeVideoQuality({
    required BuildContext context,
    required String selectedSource,
  }) async {
    if (_getCurrentVideoPlayerSource() == selectedSource) {
      Navigator.of(context).pop();
    } else {
      await customVideoPlayerController.switchVideoSource(selectedSource);
      Navigator.of(context).pop();
    }
  }
}
