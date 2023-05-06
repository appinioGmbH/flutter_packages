import 'package:flutter/material.dart';

class ModalItemWrapper {
  final String text;
  final Color? textColor;
  final IconData? icon;
  final Color? iconColor;
  final Color disabledColor;
  final VoidCallback? callback;

  ModalItemWrapper(
      {required this.text,
      Color? textColor,
      this.icon,
      Color? iconColor,
      Color? foregroundColor,
      Color? disabledColor,
      this.callback})
      : textColor = textColor ?? foregroundColor,
        iconColor = iconColor ?? foregroundColor,
        disabledColor = disabledColor ?? Colors.grey.shade600;

  bool get isEnabled => callback != null;
}
