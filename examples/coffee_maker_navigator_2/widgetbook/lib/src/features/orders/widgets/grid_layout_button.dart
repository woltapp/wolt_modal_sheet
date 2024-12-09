import 'package:coffee_maker_navigator_2/features/orders/ui/widgets/grid_layout_button.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'GridLayoutButton',
  type: GridLayoutButton,
  path: 'Orders/Widgets',
)
Widget gridLayoutButton(BuildContext context) {
  return Center(
    child: GridLayoutButton(
      isGridOverlayVisible: ValueNotifier(
        context.knobs.boolean(
          label: 'Grid Overlay Visibility',
          description: 'Whether the grid overlay is visible',
          initialValue: false,
        ),
      ),
    ),
  );
}
