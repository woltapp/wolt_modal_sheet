import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'AddWaterScreenContent',
  type: AddWaterScreenContent,
  path: 'Add Water/Widgets',
)
Widget addWaterScreenContent(BuildContext context) {
  return Scaffold(
    body: AddWaterScreenContent(
      isReadyToAddWater: ValueNotifier(
        context.knobs.boolean(
          label: 'Is Ready To Add Water',
          initialValue: false,
        ),
      ),
      errorMessage: ValueNotifier(
        context.knobs.string(
          label: 'Error Message',
          initialValue: 'Error message',
        ),
      ),
      onWaterQuantityUpdated: (_) {},
      onWaterTemperatureUpdated: (_) {},
      onWaterSourceUpdated: (_) {},
      onCheckValidityPressed: () {},
      onAddWaterPressed: () {},
      onStepCompleted: () {},
    ),
  );
}
