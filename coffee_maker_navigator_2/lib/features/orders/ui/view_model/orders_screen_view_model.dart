import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/orders_service.dart';
import 'package:flutter/foundation.dart';

class OrdersScreenViewModel {
  final ValueNotifier<CoffeeMakerStep> selectedNavBarTabListenable =
      ValueNotifier(CoffeeMakerStep.grind);

  OrdersScreenViewModel({required OrdersService ordersService})
      : _ordersService = ordersService {
    final currentOrders = _ordersService.orders.value;
    _groupedCoffeeOrders.value =
        GroupedCoffeeOrders.fromCoffeeOrders(currentOrders);
    _ordersService.orders.addListener(_onOrdersReceived);
  }

  final OrdersService _ordersService;

  final _groupedCoffeeOrders = ValueNotifier(GroupedCoffeeOrders.empty());
  void onInit(CoffeeMakerStep? initialNavBarItem) {
    selectedNavBarTabListenable.value = initialNavBarItem ?? CoffeeMakerStep.grind;
  }

  ValueListenable<GroupedCoffeeOrders> get groupedCoffeeOrders =>
      _groupedCoffeeOrders;

  void dispose() {
    _ordersService.orders.removeListener(_onOrdersReceived);
  }

  void onNavBarItemSelected(CoffeeMakerStep selectedStep) {
    selectedNavBarTabListenable.value = selectedStep;
  }

  void onOrderStatusChange(String orderId, [CoffeeMakerStep? newStep]) {
    _ordersService.updateOrder(orderId, newStep);
  }

  void _onOrdersReceived() {
    final orders = _ordersService.orders.value;
    _groupedCoffeeOrders.value = GroupedCoffeeOrders.fromCoffeeOrders(orders);
  }

  bool orderExists(String orderId, CoffeeMakerStep step) {
    return _ordersService.orders.value
        .any((order) => order.id == orderId && order.coffeeMakerStep == step);
  }
}
