import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/orders_service.dart';
import 'package:flutter/foundation.dart';

class OrdersScreenViewModel {
  late final ValueNotifier<CoffeeMakerStep> _selectedNavBarTab;

  ValueListenable<CoffeeMakerStep> get selectedNavBarTab => _selectedNavBarTab;

  late ValueNotifier<GroupedCoffeeOrders> _groupedCoffeeOrders;

  ValueListenable<GroupedCoffeeOrders> get groupedCoffeeOrders => _groupedCoffeeOrders;

  OrdersScreenViewModel({
    required OrdersService ordersService,
  }) : _ordersService = ordersService {
    _groupedCoffeeOrders = ValueNotifier(GroupedCoffeeOrders.fromCoffeeOrders(
      _ordersService.orders.value,
    ));
    _selectedNavBarTab = ValueNotifier(CoffeeMakerStep.grind);
    _ordersService.orders.addListener(_onOrdersReceived);
  }

  final OrdersService _ordersService;

  void onInit(CoffeeMakerStep? initialNavBarItem) {
    _selectedNavBarTab.value = initialNavBarItem ?? CoffeeMakerStep.grind;
  }

  void dispose() {
    _ordersService.orders.removeListener(_onOrdersReceived);
  }

  void onNavBarItemSelected(CoffeeMakerStep selectedStep) {
    _selectedNavBarTab.value = selectedStep;
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
