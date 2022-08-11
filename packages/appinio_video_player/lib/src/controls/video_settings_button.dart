import 'package:appinio_video_player/src/controls/video_settings_popup/video_settings_dialog.dart';
import 'package:appinio_video_player/src/custom_video_player_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoSettingsButton extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  final Function updateVideoState;
  const VideoSettingsButton({
    Key? key,
    required this.customVideoPlayerController,
    required this.updateVideoState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openVideoSettingsDialog(context),
      child:
          customVideoPlayerController.customVideoPlayerSettings.settingsButton,
    );
  }

  Future<void> _openVideoSettingsDialog(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "custom_video_player_controls_barrier1",
      pageBuilder: (context, _, __) => VideoSettingsDialog(
        customVideoPlayerController: customVideoPlayerController,
        updateViewOnClose: updateVideoState,
      ),
    );
    updateVideoState();
  }
}

class CustomVideoPlayerSettingsButton extends StatelessWidget {
  const CustomVideoPlayerSettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: const Icon(
        CupertinoIcons.settings,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}
