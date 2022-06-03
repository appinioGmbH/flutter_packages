import 'package:flutter/material.dart';

class CustomVideoPlayerPopupSettings {
  final String popupTitle;
  final String popupQualityTitle;
  final String popupPlaybackSpeedTitle;
  final String defaultPlaybackspeedDescription;
  final TextStyle popupTitleTextStyle;
  final BoxDecoration popupDecoration;
  final double popupWidth;
  final EdgeInsets popupPadding;
  final TextStyle popupItemsTextStyle;
  final EdgeInsets popupItemsPadding;
  final BoxDecoration popupItemsDecoration;
  const CustomVideoPlayerPopupSettings({
    this.popupTitle = 'Video Settings',
    this.popupQualityTitle = 'Video Quality',
    this.popupPlaybackSpeedTitle = 'Playback Speed',
    this.popupTitleTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    this.popupDecoration = const BoxDecoration(
      color: Color.fromARGB(255, 41, 40, 40),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    this.popupWidth = 300,
    this.popupPadding = const EdgeInsets.all(8),
    this.popupItemsTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
    this.popupItemsPadding = const EdgeInsets.all(8),
    this.popupItemsDecoration = const BoxDecoration(),
    this.defaultPlaybackspeedDescription = 'Default',
  });
}
