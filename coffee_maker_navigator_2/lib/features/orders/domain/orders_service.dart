import 'package:coffee_maker_navigator_2/features/orders/data/repository/orders_repository.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_order.dart';
import 'package:flutter/foundation.dart';

class OrdersService {
  final OrdersRepository _ordersRepository;

  const OrdersService({
    required OrdersRepository ordersRepository,
  }) : _ordersRepository = ordersRepository;

  ValueListenable<List<CoffeeOrder>> receiveOrders() {
    return _ordersRepository.receiveOrders();
  }

  /// Callback method invoked when the status of a coffee order changes.
  ///
  /// The [orderId] is the ID of the coffee order that had its status changed.
  ///
  /// The optional [newStep] parameter represents the new status of the coffee order.
  /// If [newStep] is provided and is either [CoffeeMakerStep.addWater] or [CoffeeMakerStep.ready],
  /// the method updates the status of the coffee order in the current list of orders. If
  /// [newStep] is not provided the method removes the coffee order.
  Future<CoffeeOrder?> updateOrder(
      String orderId, CoffeeMakerStep? newStep) async {
    /// This is where we implement the business logic. The data logic is handled by the repository.
    final currentList = receiveOrders().value;
    final updateIndex = currentList.indexWhere((o) => o.id == orderId);
    final orderToUpdate = currentList.elementAtOrNull(updateIndex);

    if (orderToUpdate != null) {
      if ([CoffeeMakerStep.addWater, CoffeeMakerStep.ready].contains(newStep)) {
        return await _ordersRepository.updateOrder(
          orderToUpdate.copyWith(coffeeMakerStep: newStep),
        );
      } else {
        await _ordersRepository.archiveOrder(orderId);
      }
    }
    return Future.value();
  }

  Future<void> archiveOrder(String id) async {
    return await _ordersRepository.archiveOrder(id);
  }
}
