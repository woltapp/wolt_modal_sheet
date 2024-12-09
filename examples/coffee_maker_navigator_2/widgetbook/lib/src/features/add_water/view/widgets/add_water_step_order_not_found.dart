import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_step_order_not_found.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'AddWaterStepOrderNotFound',
  type: AddWaterStepOrderNotFound,
  path: 'Add Water/Widgets',
)
Widget addWaterStepOrderNotFound(BuildContext context) {
  return Scaffold(
    body: AddWaterStepOrderNotFound(
      onOrderStepCompleted: () {},
    ),
  );
}
