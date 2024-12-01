import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Primary', type: WoltElevatedButton)
Widget primaryButton(BuildContext context) {
  return Center(
    child: WoltElevatedButton(
      onPressed: () {},
      theme: context.knobs.list(
        label: 'Theme',
        options: WoltElevatedButtonTheme.values,
        initialOption: WoltElevatedButtonTheme.primary,
        labelBuilder: (option) {
          switch (option) {
            case WoltElevatedButtonTheme.primary:
              return 'Primary';
            case WoltElevatedButtonTheme.secondary:
              return 'Secondary';
          }
        },
      ),
      child: Text(
        context.knobs.string(
          label: 'Text',
          initialValue: 'Button',
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
