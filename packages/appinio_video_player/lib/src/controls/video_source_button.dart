import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:appinio_video_player/src/custom_video_player_controller.dart';

class VideoSourceButton extends StatefulWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  final Function updateVideoState;
  const VideoSourceButton({
    Key? key,
    required this.customVideoPlayerController,
    required this.updateVideoState,
  }) : super(key: key);

  @override
  State<VideoSourceButton> createState() => _VideoSourceButtonState();
}

class _VideoSourceButtonState extends State<VideoSourceButton> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _switchVideoSource(String sourcePath) async {
    Duration _playedDuration =
        widget.customVideoPlayerController.videoPlayerController.value.position;
    widget.customVideoPlayerController.videoPlayerController.dispose();
    widget.customVideoPlayerController.videoPlayerController = widget
        .customVideoPlayerController.additionalVideoSources!.entries
        .toList()[1]
        .value;
    await widget.customVideoPlayerController.videoPlayerController.initialize();
    widget.customVideoPlayerController.initialize();
    await widget.customVideoPlayerController.videoPlayerController
        .seekTo(_playedDuration);
    await widget.customVideoPlayerController.videoPlayerController.play();
    widget.updateVideoState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customVideoPlayerController.additionalVideoSources != null &&
        widget.customVideoPlayerController.additionalVideoSources!.entries
            .isNotEmpty) {
      return GestureDetector(
        onTap: () => _openChangeQualityDialog(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Row(
            children: const [
              Icon(
                CupertinoIcons.settings,
                color: Colors.white,
                size: 14,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                "HD",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  _openChangeQualityDialog() async {
    // showDialog(
    //     context: context, builder: (context) => ChangeVideoQualityDialog());
    await widget.customVideoPlayerController.switchVideoSource("dsaf");
    widget.updateVideoState();
    // _switchVideoSource(
    //     'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4');
  }
}

class ChangeVideoQualityDialog extends StatelessWidget {
  const ChangeVideoQualityDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Change video quality",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            _videoSourceDropdownItem(
              name: "B=njkdaf",
              selected: true,
            ),
            _videoSourceDropdownItem(
              name: "B=njkdaf",
              selected: false,
            ),
            _videoSourceDropdownItem(
              name: "B=njkdaf",
              selected: false,
            ),
            _videoSourceDropdownItem(
              name: "B=njkdaf",
              selected: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _videoSourceDropdownItem({
    required String name,
    required bool selected,
  }) {
    return GestureDetector(
      // onTap: ,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const Spacer(),
            if (selected)
              const Icon(
                CupertinoIcons.check_mark,
                color: Colors.white,
                size: 18,
              )
          ],
        ),
      ),
    );
  }
}
