import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:example/constants/demo_app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WaterQuantityTemperatureInput extends StatelessWidget {
  const WaterQuantityTemperatureInput({
    required this.suffixText,
    required this.controller,
    required this.scrollPadding,
    super.key,
  });

  final String suffixText;
  final TextEditingController controller;
  final EdgeInsets? scrollPadding;

  @override
  Widget build(BuildContext context) {
    return WoltTextInput(
      scrollPadding: scrollPadding,
      controller: controller,
      inputFormatters: [
        /* Don't allow minus or space */
        FilteringTextInputFormatter.deny(RegExp(r'(\s|-+)')),
      ],
      suffix: Text(
        suffixText,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: DemoAppColors.black64,
        ),
      ),
    );
  }
}
