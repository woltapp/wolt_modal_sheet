import 'package:coffee_maker/entities/coffee_maker_step.dart';
import 'package:coffee_maker/entities/coffee_order.dart';
import 'package:equatable/equatable.dart';

/// Represents a group of coffee orders categorized by their current coffee maker step.
/// The orders are grouped into three lists: grindStateOrders, addWaterStateOrders, and readyStateOrders.
class GroupedCoffeeOrders extends Equatable {
  /// The list of coffee orders in the grind state.
  final List<CoffeeOrder> grindStateOrders;

  /// The list of coffee orders in the add water state.
  final List<CoffeeOrder> addWaterStateOrders;

  /// The list of coffee orders in the ready state.
  final List<CoffeeOrder> readyStateOrders;

  /// Creates a new instance of [GroupedCoffeeOrders] with the specified lists of coffee orders.
  const GroupedCoffeeOrders({
    required this.grindStateOrders,
    required this.addWaterStateOrders,
    required this.readyStateOrders,
  });

  /// Creates a new instance of [GroupedCoffeeOrders] from a list of [CoffeeOrder]s.
  factory GroupedCoffeeOrders.fromCoffeeOrders(List<CoffeeOrder> coffeeOrders) {
    final grindStateOrders =
        coffeeOrders.where((o) => o.coffeeMakerStep == CoffeeMakerStep.grind).toList();
    final addWaterStateOrders =
        coffeeOrders.where((o) => o.coffeeMakerStep == CoffeeMakerStep.addWater).toList();
    final readyStateOrders =
        coffeeOrders.where((o) => o.coffeeMakerStep == CoffeeMakerStep.ready).toList();
    return GroupedCoffeeOrders(
      grindStateOrders: grindStateOrders,
      addWaterStateOrders: addWaterStateOrders,
      readyStateOrders: readyStateOrders,
    );
  }

  /// Gets a list of all coffee orders across all states.
  List<CoffeeOrder> get allOrders => [
        ...grindStateOrders,
        ...addWaterStateOrders,
        ...readyStateOrders,
      ];

  @override
  List<Object?> get props => [grindStateOrders, addWaterStateOrders, readyStateOrders];

  /// Returns the count of coffee orders for a specific coffee maker step.
  int countForStep(CoffeeMakerStep step) {
    switch (step) {
      case CoffeeMakerStep.grind:
        return grindStateOrders.length;
      case CoffeeMakerStep.addWater:
        return addWaterStateOrders.length;
      case CoffeeMakerStep.ready:
        return readyStateOrders.length;
    }
  }
}
