import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_order.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/widgets/coffee_order_list_item_tile.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'CoffeeOrderListItemTile',
  type: CoffeeOrderListItemTile,
  path: 'Orders/View/Widgets',
)
Widget coffeeOrderListItemTile(BuildContext context) {
  return CoffeeOrderListItemTile(
    coffeeOrder: CoffeeOrder(
      id: context.knobs.int
          .input(
            label: 'Coffee Order Id',
            description: 'The ID of the coffee order.',
            initialValue: 1,
          )
          .toString(),
      coffeeMakerStep: context.knobs.list(
        label: 'Coffee Maker Step',
        description: 'The current step of the coffee order.',
        options: CoffeeMakerStep.values,
        initialOption: CoffeeMakerStep.grind,
        labelBuilder: (value) => value.stepName,
      ),
      orderName: context.knobs.string(
        label: 'Order Name',
        initialValue: 'Latte',
        description: 'The name of the coffee order.',
      ),
    ),
    onSelected: (_) {},
  );
}
