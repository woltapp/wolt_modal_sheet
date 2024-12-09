import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';

class CoffeeMakerCustomDivider extends StatelessWidget {
  const CoffeeMakerCustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: WoltColors.gray,
      child: SizedBox(height: 1, width: double.infinity),
    );
  }
}
