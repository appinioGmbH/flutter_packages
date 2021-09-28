import 'package:flutter/material.dart';

class CustomVideoPlayerController extends ChangeNotifier {
  /// Gives information over fullscreen state.
  bool isFullscreen = false;

  ///Gives inforamtion over control bar visibilty.
  bool controlBarVisible = true;

  /// Sets the fullscreen mode to the given new value.
  void setFullscreen(bool newValue) {
    isFullscreen = newValue;
    notifyListeners();
  }

  /// Sets the control bar visibility to the given new value.
  void setControlBarVisibility(bool newValue) {
    controlBarVisible = newValue;
    notifyListeners();
  }
}
