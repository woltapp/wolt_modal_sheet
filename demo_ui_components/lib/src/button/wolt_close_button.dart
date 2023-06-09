import 'package:demo_ui_components/src/button/wolt_circular_elevated_button.dart';
import 'package:flutter/material.dart';

class WoltCloseButton extends StatelessWidget {
  const WoltCloseButton({this.onClosed, super.key});

  final VoidCallback? onClosed;

  @override
  Widget build(BuildContext context) {
    return WoltCircularElevatedButton(
      onPressed: onClosed ?? Navigator.of(context).pop,
      icon: Icons.close,
    );
  }
}
