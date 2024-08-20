import 'dart:async';

import 'package:coffee_maker_navigator_2/app/app_lifecycle/domain/app_lifecyle_service.dart';
import 'package:coffee_maker_navigator_2/features/orders/data/repository/orders_repository.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_order.dart';
import 'package:flutter/foundation.dart';

class OrdersService {
  final OrdersRepository _ordersRepository;
  Timer? _pollingTimer;

  final ValueNotifier<List<CoffeeOrder>> _orders = ValueNotifier([]);

  static const Duration pollingInterval = Duration(seconds: 3);

  OrdersService({
    required OrdersRepository ordersRepository,
    required AppLifeCycleService appLifeCycleService,
  }) : _ordersRepository = ordersRepository {
    _startPolling();
    appLifeCycleService.appLifeStateListenable.addListener(() {
      _onAppLifeCycleChange(appLifeCycleService.appLifeStateListenable.value);
    });
  }

  ValueListenable<List<CoffeeOrder>> get orders => _orders;

  void dispose() {
    _stopPolling();
    _orders.dispose();
  }

  /// Callback method invoked when the status of a coffee order changes.
  ///
  /// The [orderId] is the ID of the coffee order that had its status changed.
  ///
  /// The optional [newStep] parameter represents the new status of the coffee order.
  /// If [newStep] is provided and is either [CoffeeMakerStep.addWater] or [CoffeeMakerStep.ready],
  /// the method updates the status of the coffee order in the current list of orders. If
  /// [newStep] is not provided the method removes the coffee order.
  void updateOrder(String orderId, CoffeeMakerStep? newStep) async {
    final currentList = orders.value;
    final updateIndex = currentList.indexWhere((o) => o.id == orderId);
    final orderToUpdate = currentList.elementAtOrNull(updateIndex);

    if (orderToUpdate != null) {
      if ([CoffeeMakerStep.addWater, CoffeeMakerStep.ready].contains(newStep)) {
        _ordersRepository
            .updateOrder(orderToUpdate.copyWith(coffeeMakerStep: newStep));
      } else {
        _ordersRepository.archiveOrder(orderId);
      }
    }
  }

  void _onAppLifeCycleChange(AppLifeCycleState appLifeCycleState) {
    switch (appLifeCycleState) {
      case AppLifeCycleState.foreground:
        _startPolling();
        break;
      case AppLifeCycleState.background:
        _stopPolling();
        break;
    }
  }

  /// Starts polling for order updates.
  void _startPolling() {
    _pollingTimer?.cancel(); // Cancel any existing timer
    _pollingTimer = Timer.periodic(pollingInterval, (timer) async {
      final updatedOrders = await _ordersRepository.fetchOrders();
      if (kDebugMode) {
        _log(updatedOrders);
      }
      _orders.value = updatedOrders;
    });
  }

  /// Stops the polling process.
  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void _log(List<CoffeeOrder> updatedOrders) {
    final now = DateTime.now();
    debugPrint(
      '${now.hour}:${now.minute}:${now.second} Polling for orders: ${updatedOrders.map(
            (e) => (e.id, e.coffeeMakerStep.stepName),
          ).toList()}',
    );
  }
}
