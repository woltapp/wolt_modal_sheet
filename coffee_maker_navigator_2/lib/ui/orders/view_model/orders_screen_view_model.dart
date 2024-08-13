import 'package:coffee_maker_navigator_2/domain/orders/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/domain/orders/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker_navigator_2/domain/orders/orders_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:wolt_di/wolt_di.dart';

class OrdersScreenViewModel implements WoltViewModel {
  final OrdersService _ordersService;
  final groupedCoffeeOrders = ValueNotifier(GroupedCoffeeOrders.empty());

  OrdersScreenViewModel({
    required OrdersService ordersService,
  }) : _ordersService = ordersService {
    final currentOrders = _ordersService.receiveOrders().value;
    groupedCoffeeOrders.value =
        GroupedCoffeeOrders.fromCoffeeOrders(currentOrders);
    _ordersService.receiveOrders().addListener(_onOrdersReceived);
  }

  @override
  void dispose() {
    _ordersService.receiveOrders().removeListener(_onOrdersReceived);
  }

  void _onOrdersReceived() {
    final orders = _ordersService.receiveOrders().value;
    groupedCoffeeOrders.value = GroupedCoffeeOrders.fromCoffeeOrders(orders);
  }

  void onCoffeeOrderStatusChange(
    String orderId, [
    CoffeeMakerStep? newStep,
  ]) {
    _ordersService.updateOrder(orderId, newStep);
  }
}
