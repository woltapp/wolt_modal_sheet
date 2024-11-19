import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'AddWaterScreenBody',
  type: AddWaterScreenBody,
  path: 'Add Water/Widgets',
)
Widget addWaterScreenBody(BuildContext context) {
  return Scaffold(
    body: AddWaterScreenBody(
      onWaterQuantityUpdated: (_) {},
      onWaterTemperatureUpdated: (_) {},
      onWaterSourceUpdated: (_) {},
    ),
  );
}
