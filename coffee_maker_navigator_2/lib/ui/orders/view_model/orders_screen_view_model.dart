import 'dart:async';

import 'package:coffee_maker_navigator_2/domain/orders/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/domain/orders/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker_navigator_2/domain/orders/orders_service.dart';
import 'package:flutter/foundation.dart';

class OrdersScreenViewModel extends ChangeNotifier {
  final OrdersService _ordersService;
  GroupedCoffeeOrders groupedCoffeeOrders = GroupedCoffeeOrders.empty();

  OrdersScreenViewModel({
    required OrdersService ordersService,
  }) : _ordersService = ordersService;

  Future<void> onInit() async {
    final currentOrders = _ordersService.receiveOrders().value;
    groupedCoffeeOrders = GroupedCoffeeOrders.fromCoffeeOrders(currentOrders);
    notifyListeners();
    _ordersService.receiveOrders().addListener(_onOrdersReceived);
  }

  @override
  void dispose() {
    _ordersService.receiveOrders().removeListener(_onOrdersReceived);
    super.dispose();
  }

  void _onOrdersReceived() {
    final orders = _ordersService.receiveOrders().value;
    groupedCoffeeOrders = GroupedCoffeeOrders.fromCoffeeOrders(orders);
    notifyListeners();
  }

  void onCoffeeOrderStatusChange(
    String orderId, [
    CoffeeMakerStep? newStep,
  ]) {
    _ordersService.updateOrder(orderId, newStep);
  }
}
