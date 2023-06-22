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
    return TextFormField(
      controller: controller,
      scrollPadding: scrollPadding ?? const EdgeInsets.all(16),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        /* Don't allow minus or space */
        FilteringTextInputFormatter.deny(RegExp(r'(\s|-+)')),
      ],
      decoration: InputDecoration(suffix: Text(suffixText)),
    );
  }
}
