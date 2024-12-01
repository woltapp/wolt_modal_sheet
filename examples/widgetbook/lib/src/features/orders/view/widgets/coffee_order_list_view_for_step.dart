import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_order.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/widgets/coffee_order_list_view_for_step.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'CoffeeOrderListViewForStep',
  type: CoffeeOrderListViewForStep,
  path: 'Orders/View/Widgets',
)
Widget coffeeOrderListViewForStep(BuildContext context) {
  return CoffeeOrderListViewForStep(
    groupedCoffeeOrders: const GroupedCoffeeOrders(
      grindStateOrders: [
        CoffeeOrder(
          id: '1',
          orderName: 'Coffee Order 1',
          coffeeMakerStep: CoffeeMakerStep.grind,
        ),
      ],
      addWaterStateOrders: [
        CoffeeOrder(
          id: '2',
          orderName: 'Coffee Order 2',
          coffeeMakerStep: CoffeeMakerStep.addWater,
        ),
      ],
      readyStateOrders: [
        CoffeeOrder(
          id: '3',
          orderName: 'Coffee Order 3',
          coffeeMakerStep: CoffeeMakerStep.ready,
        ),
      ],
    ),
    selectedBottomNavBarItem: context.knobs.list(
      label: 'Coffee Maker Step',
      description: 'The current step of the coffee order.',
      options: CoffeeMakerStep.values,
      initialOption: CoffeeMakerStep.grind,
      labelBuilder: (value) => value.stepName,
    ),
    onGrindCoffeeStepSelected: (_) {},
    onAddWaterCoffeeStepSelected: (_) {},
    onReadyCoffeeStepSelected: (_) {},
  );
}
