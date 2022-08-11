import 'package:appinio_video_player/src/models/custom_video_player_popup_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoSettingsDialogItem extends StatefulWidget {
  final String title;
  final Function onPressed;
  final bool? selected;
  final CustomVideoPlayerPopupSettings popupSettings;

  const VideoSettingsDialogItem({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.popupSettings,
    this.selected,
  }) : super(key: key);

  @override
  State<VideoSettingsDialogItem> createState() =>
      _VideoSettingsDialogItemState();
}

class _VideoSettingsDialogItemState extends State<VideoSettingsDialogItem> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onPressed(),
      child: Container(
        padding: widget.popupSettings.popupItemsPadding,
        decoration: widget.popupSettings.popupItemsDecoration,
        child: Row(
          children: [
            Text(
              widget.title,
              style: widget.popupSettings.popupItemsTextStyle,
            ),
            const Spacer(),
            widget.selected == null
                ? Icon(
                    CupertinoIcons.chevron_right,
                    color: widget.popupSettings.popupItemsTextStyle.color,
                    size: widget.popupSettings.popupItemsTextStyle.fontSize,
                  )
                : _loading
                    ? SizedBox(
                        width:
                            widget.popupSettings.popupItemsTextStyle.fontSize ??
                                14,
                        height:
                            widget.popupSettings.popupItemsTextStyle.fontSize ??
                                14,
                        child: CircularProgressIndicator(
                          color: widget.popupSettings.popupItemsTextStyle.color,
                          strokeWidth: 1,
                        ),
                      )
                    : widget.selected!
                        ? Icon(
                            CupertinoIcons.check_mark,
                            color:
                                widget.popupSettings.popupItemsTextStyle.color,
                            size: widget
                                .popupSettings.popupItemsTextStyle.fontSize,
                          )
                        : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  _onPressed() async {
    setState(() {
      _loading = true;
    });

    await widget.onPressed();
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }
}
