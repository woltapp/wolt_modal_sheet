import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'TopBar',
  type: TopBar,
  path: 'Orders/Widgets',
)
Widget storeOnlineStatusButton(BuildContext context) {
  return Center(
    child: TopBar(
      selectedTab: context.knobs.list(
        label: 'Selected Tab',
        initialOption: CoffeeMakerStep.grind,
        options: CoffeeMakerStep.values,
        labelBuilder: (value) => value.stepName,
      ),
    ),
  );
}
