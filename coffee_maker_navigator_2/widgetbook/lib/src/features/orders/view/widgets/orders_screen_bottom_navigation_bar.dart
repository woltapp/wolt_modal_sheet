import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_order.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/widgets/orders_screen_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'Filled',
  type: OrdersScreenBottomNavigationBar,
  path: 'Orders/View/Widgets',
)
Widget ordersScreenBottomNavigationBarFilled(BuildContext context) {
  return Scaffold(
    bottomNavigationBar: OrdersScreenBottomNavigationBar(
      ValueNotifier(
        const GroupedCoffeeOrders(
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
      ),
      (_) {},
      ValueNotifier(
        context.knobs.list(
          label: 'Bottom Navigation Bar Step',
          description: 'The current step of the coffee order.',
          options: CoffeeMakerStep.values,
          initialOption: CoffeeMakerStep.grind,
          labelBuilder: (value) => value.stepName,
        ),
      ),
    ),
  );
}

@UseCase(
  name: 'Empty',
  type: OrdersScreenBottomNavigationBar,
  path: 'Orders/View/Widgets',
)
Widget ordersScreenBottomNavigationBarEmpty(BuildContext context) {
  return Scaffold(
    bottomNavigationBar: OrdersScreenBottomNavigationBar(
      ValueNotifier(GroupedCoffeeOrders.empty()),
      (_) {},
      ValueNotifier(
        context.knobs.list(
          label: 'Bottom Navigation Bar Step',
          description: 'The current step of the coffee order.',
          options: CoffeeMakerStep.values,
          initialOption: CoffeeMakerStep.grind,
          labelBuilder: (value) => value.stepName,
        ),
      ),
    ),
  );
}
