import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';

class WoltCircularElevatedButton extends StatelessWidget {
  const WoltCircularElevatedButton(
      {required this.onPressed, required this.icon, super.key});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const iconColor = WoltColors.black;
    const fillColor = WoltColors.black8;
    return RawMaterialButton(
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      fillColor: fillColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      highlightColor: iconColor.withOpacity(.1),
      splashColor: iconColor.withOpacity(.1),
      constraints: const BoxConstraints.expand(width: 40, height: 40),
      onPressed: onPressed,
      shape: const CircleBorder(),
      child: Icon(icon, size: 24.0, color: Colors.black),
    );
  }
}
