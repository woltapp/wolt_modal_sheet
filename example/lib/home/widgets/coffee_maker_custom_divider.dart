import 'package:flutter/material.dart';
import 'package:example/constants/demo_app_colors.dart';

class CoffeeMakerCustomDivider extends StatelessWidget {
  const CoffeeMakerCustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: DemoAppColors.gray,
      child: SizedBox(height: 1, width: double.infinity),
    );
  }
}
