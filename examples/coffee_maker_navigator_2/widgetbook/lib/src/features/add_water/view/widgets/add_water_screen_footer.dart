import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_screen_footer.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'AddWaterScreenFooter',
  type: AddWaterScreenFooter,
  path: 'Add Water/Widgets',
)
Widget addWaterScreenFooter(BuildContext context) {
  return Scaffold(
    body: AddWaterScreenFooter(
      ValueNotifier(
        context.knobs.boolean(
          label: 'Is Ready To Add Water',
          initialValue: false,
        ),
      ),
      ValueNotifier(
        context.knobs.string(
          label: 'Error Message',
          initialValue: 'Error message',
        ),
      ),
      () {},
      () {},
      () {},
    ),
  );
}
