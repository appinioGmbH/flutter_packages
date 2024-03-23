import 'package:appinio_video_player/src/controls/video_settings_popup/video_settings_dialog_item.dart';
import 'package:appinio_video_player/src/custom_video_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:appinio_video_player/appinio_video_player.dart';

class VideoSettingsQualityDialog extends StatefulWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  final Function updateView;
  const VideoSettingsQualityDialog({
    Key? key,
    required this.customVideoPlayerController,
    required this.updateView,
  }) : super(key: key);

  @override
  State<VideoSettingsQualityDialog> createState() =>
      _VideoSettingsQualityDialogState();
}

class _VideoSettingsQualityDialogState
    extends State<VideoSettingsQualityDialog> {
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
                  .customVideoPlayerPopupSettings.popupQualityTitle,
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
                controller: ScrollController(),
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                children: [
                  for (MapEntry<String, CachedVideoPlayerController> videoSource
                      in widget.customVideoPlayerController
                          .additionalVideoSources!.entries)
                    VideoSettingsDialogItem(
                      title: videoSource.key,
                      popupSettings: widget
                          .customVideoPlayerController
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
    return widget.customVideoPlayerController.additionalVideoSources!.entries
        .toList()
        .firstWhere((element) =>
            element.value ==
            widget.customVideoPlayerController.videoPlayerController)
        .key;
  }

  void _changeVideoQuality({
    required BuildContext context,
    required String selectedSource,
  }) async {
    if (_getCurrentVideoPlayerSource() != selectedSource) {
      await widget.customVideoPlayerController
          .switchVideoSource(selectedSource);
      widget.updateView();
      //maybe popup was dismissed on barrier tap before
      if (mounted) {
        setState(() {});
      }
    }
  }
}
