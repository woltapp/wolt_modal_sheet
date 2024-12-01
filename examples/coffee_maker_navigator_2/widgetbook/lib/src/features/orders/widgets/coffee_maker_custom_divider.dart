import 'package:coffee_maker_navigator_2/features/orders/ui/widgets/coffee_maker_custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'CoffeeMakerCustomDivider',
  type: CoffeeMakerCustomDivider,
  path: 'Orders/Widgets',
)
Widget coffeeMakerCustomDivider(BuildContext context) {
  return const Scaffold(
    body: Center(child: CoffeeMakerCustomDivider()),
  );
}
