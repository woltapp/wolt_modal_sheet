import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_order.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/widgets/coffee_order_list_item_tile.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/widgets/order_screen_content.dart';
import 'package:flutter/material.dart';

class CoffeeOrderListViewForStep extends StatelessWidget {
  const CoffeeOrderListViewForStep({
    required this.groupedCoffeeOrders,
    required this.selectedBottomNavBarItem,
    required this.onGrindCoffeeStepSelected,
    required this.onAddWaterCoffeeStepSelected,
    required this.onReadyCoffeeStepSelected,
    super.key,
  });

  final GroupedCoffeeOrders groupedCoffeeOrders;
  final CoffeeMakerStep selectedBottomNavBarItem;
  final OnCoffeeOrderUpdate onGrindCoffeeStepSelected;
  final OnCoffeeOrderUpdate onAddWaterCoffeeStepSelected;
  final OnCoffeeOrderUpdate onReadyCoffeeStepSelected;

  @override
  Widget build(BuildContext context) {
    late Widget listView;

    switch (selectedBottomNavBarItem) {
      case CoffeeMakerStep.grind:
        listView = _CoffeeOrderListView(
          coffeeOrders: groupedCoffeeOrders.grindStateOrders,
          onCoffeeOrderSelected: onGrindCoffeeStepSelected,
        );
      case CoffeeMakerStep.addWater:
        listView = _CoffeeOrderListView(
          coffeeOrders: groupedCoffeeOrders.addWaterStateOrders,
          onCoffeeOrderSelected: onAddWaterCoffeeStepSelected,
        );
      case CoffeeMakerStep.ready:
        listView = _CoffeeOrderListView(
          coffeeOrders: groupedCoffeeOrders.readyStateOrders,
          onCoffeeOrderSelected: onReadyCoffeeStepSelected,
        );
    }

    return Container(
      alignment: Alignment.topCenter,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: listView,
    );
  }
}

class _CoffeeOrderListView extends StatelessWidget {
  const _CoffeeOrderListView({
    required this.coffeeOrders,
    required OnCoffeeOrderUpdate onCoffeeOrderSelected,
  }) : _onCoffeeOrderSelected = onCoffeeOrderSelected;

  final List<CoffeeOrder> coffeeOrders;
  final ValueChanged<String> _onCoffeeOrderSelected;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: ListView.separated(
        itemBuilder: (_, index) {
          final coffeeOrder = coffeeOrders[index];
          return Column(
            children: [
              if (index == 0) const SizedBox(height: 16),
              CoffeeOrderListItemTile(
                coffeeOrder: coffeeOrder,
                onSelected: _onCoffeeOrderSelected,
              ),
              if (index == coffeeOrders.length - 1) const SizedBox(height: 16),
            ],
          );
        },
        itemCount: coffeeOrders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
      ),
    );
  }
}
