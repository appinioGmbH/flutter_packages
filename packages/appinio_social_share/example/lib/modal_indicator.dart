import 'package:flutter/material.dart';

class ModalIndicator extends StatelessWidget {
  final EdgeInsets margin;
  final Color? color;
  const ModalIndicator({
    Key? key,
    this.color,
    this.margin = const EdgeInsets.symmetric(vertical: 12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 40,
      height: 4,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: color ?? Colors.grey,
      ),
    );
  }
}
