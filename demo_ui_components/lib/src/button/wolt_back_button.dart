import 'package:demo_ui_components/src/button/wolt_circular_elevated_button.dart';
import 'package:flutter/material.dart';

class WoltBackButton extends StatelessWidget {
  const WoltBackButton({required this.onBackPressed, super.key});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return WoltCircularElevatedButton(onPressed: onBackPressed, icon: Icons.arrow_back_rounded);
  }
}
