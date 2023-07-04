import 'package:coffee_maker/entities/coffee_maker_step.dart';
import 'package:coffee_maker/entities/coffee_order.dart';
import 'package:coffee_maker/home/online/widgets/coffee_order_list_item_tile.dart';
import 'package:coffee_maker/home/online/widgets/empty_coffee_order_list_widget.dart';
import 'package:flutter/material.dart';

/// A widget that displays a list of coffee orders for a specific coffee maker step.
///
/// This widget takes a list of coffee orders, a coffee maker step, and a callback function for when a coffee order is selected.
/// It renders either an empty list message or a scrollable list of coffee order items.
class CoffeeOrderListWidget extends StatelessWidget {
  const CoffeeOrderListWidget({
    required this.coffeeOrders,
    required CoffeeMakerStep coffeeMakerStep,
    required void Function(String) onCoffeeOrderSelected,
    super.key,
  })  : _onCoffeeOrderSelected = onCoffeeOrderSelected,
        _coffeeMakerStep = coffeeMakerStep;

  final List<CoffeeOrder> coffeeOrders;
  final CoffeeMakerStep _coffeeMakerStep;
  final ValueChanged<String> _onCoffeeOrderSelected;

  @override
  Widget build(BuildContext context) {
    return coffeeOrders.isEmpty
        ? EmptyCoffeeOrderList(coffeeMakerStep: _coffeeMakerStep)
        : ListView.separated(
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
          );
  }
}
