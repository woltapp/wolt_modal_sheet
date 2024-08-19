import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/orders_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:wolt_di/wolt_di.dart';

class OrdersScreenViewModel implements WoltViewModel {
  final OrdersService _ordersService;
  final groupedCoffeeOrders = ValueNotifier(GroupedCoffeeOrders.empty());
  final ValueNotifier<CoffeeMakerStep> selectedBottomNavBarItem =
      ValueNotifier(CoffeeMakerStep.grind);

  OrdersScreenViewModel({
    required OrdersService ordersService,
  }) : _ordersService = ordersService {
    final currentOrders = _ordersService.orders.value;
    groupedCoffeeOrders.value =
        GroupedCoffeeOrders.fromCoffeeOrders(currentOrders);
    _ordersService.orders.addListener(_onOrdersReceived);
  }

  void onInit(CoffeeMakerStep? initialNavBarItem) {
    selectedBottomNavBarItem.value = initialNavBarItem ?? CoffeeMakerStep.grind;
  }

  @override
  void dispose() {
    _ordersService.orders.removeListener(_onOrdersReceived);
  }

  void _onOrdersReceived() {
    final orders = _ordersService.orders.value;
    groupedCoffeeOrders.value = GroupedCoffeeOrders.fromCoffeeOrders(orders);
  }

  void onBottomNavBarItemSelected(CoffeeMakerStep selectedStep) {
    selectedBottomNavBarItem.value = selectedStep;
  }

  void onOrderStatusChange(String orderId, [CoffeeMakerStep? newStep]) {
    _ordersService.updateOrder(orderId, newStep);
  }
}
