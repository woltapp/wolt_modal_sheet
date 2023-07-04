import 'package:coffee_maker/entities/coffee_maker_step.dart';
import 'package:coffee_maker/entities/coffee_order.dart';
import 'package:coffee_maker/entities/grouped_coffee_orders.dart';
import 'package:flutter/foundation.dart';

class StoreOnlineViewModel extends ChangeNotifier {
  late GroupedCoffeeOrders _groupedCoffeeOrders;

  GroupedCoffeeOrders get groupedCoffeeOrders => _groupedCoffeeOrders;

  void onInit({required GroupedCoffeeOrders groupedCoffeeOrders}) {
    _groupedCoffeeOrders = groupedCoffeeOrders;
    notifyListeners();
  }

  /// Callback method invoked when the status of a coffee order changes.
  ///
  /// The [coffeeOrderId] is the ID of the coffee order that had its status changed.
  /// The optional [newStep] parameter represents the new status of the coffee order.
  /// If [newStep] is provided and is either [CoffeeMakerStep.addWater] or [CoffeeMakerStep.ready],
  /// the method updates the status of the coffee order in the current list of orders.
  /// If [newStep] is not provided the method removes the coffee order from the current list of
  /// orders.
  /// Finally, the method triggers a state update to reflect the changes in the UI.
  void onCoffeeOrderStatusChange(String coffeeOrderId, [CoffeeMakerStep? newStep]) {
    final currentList = List<CoffeeOrder>.from(_groupedCoffeeOrders.allOrders);
    final updateIndex = currentList.indexWhere((o) => o.id == coffeeOrderId);

    if ([CoffeeMakerStep.addWater, CoffeeMakerStep.ready].contains(newStep)) {
      currentList[updateIndex] = currentList[updateIndex].copyWith(coffeeMakerStep: newStep);
    } else {
      currentList.removeAt(updateIndex);
    }

    _groupedCoffeeOrders = GroupedCoffeeOrders.fromCoffeeOrders(currentList);
    notifyListeners();
  }
}
