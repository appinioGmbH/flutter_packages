import 'package:appinio_video_player/src/controls/video_settings_popup/video_settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:appinio_video_player/src/custom_video_player_controller.dart';

class VideoSettingsButton extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  final Function updateVideoState;
  final bool visible;
  const VideoSettingsButton({
    Key? key,
    required this.customVideoPlayerController,
    required this.updateVideoState,
    required this.visible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      maintainAnimation: true,
      maintainState: true,
      child: GestureDetector(
        onTap: () => _openVideoSettingsDialog(context),
        child: Container(
          padding: customVideoPlayerController
              .customVideoPlayerSettings.settingsButtonPadding,
          decoration: customVideoPlayerController
              .customVideoPlayerSettings.settingsButtonDecoration,
          child: customVideoPlayerController
              .customVideoPlayerSettings.settingsButtonIcon,
        ),
      ),
    );
  }

  _openVideoSettingsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => VideoSettingsDialog(
        customVideoPlayerController: customVideoPlayerController,
        updateViewOnClose: updateVideoState,
      ),
    );
    updateVideoState();
  }
}
