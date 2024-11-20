import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_order.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/widgets/order_screen_content.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'OrderScreenContent', type: OrderScreenContent)
Widget orderScreenContent(BuildContext context) {
  return OrderScreenContent(
    selectedNavBarTabListenable: ValueNotifier(
      context.knobs.list(
        label: 'CoffeeMakerStep',
        options: CoffeeMakerStep.values,
      ),
    ),
    groupedCoffeeOrders: ValueNotifier(
      GroupedCoffeeOrders.fromCoffeeOrders(
        const [
          CoffeeOrder(
            id: '1',
            coffeeMakerStep: CoffeeMakerStep.grind,
            orderName: 'Latte',
          ),
          CoffeeOrder(
            id: '2',
            coffeeMakerStep: CoffeeMakerStep.addWater,
            orderName: 'Espresso',
          ),
        ],
      ),
    ),
    onNavBarItemSelected: (_) {},
    onGrindCoffeeStepSelected: (_) {},
    onAddWaterCoffeeStepSelected: (_) {},
    onReadyCoffeeStepSelected: (_) {},
  );
}
