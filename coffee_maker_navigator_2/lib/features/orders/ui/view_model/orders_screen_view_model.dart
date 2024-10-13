import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/orders_service.dart';
import 'package:coffee_maker_navigator_2/utils/state_management/stateful_value_notifier.dart';

class OrdersScreenViewModel {
  OrdersScreenViewModel({required OrdersService ordersService})
      : _ordersService = ordersService {
    _groupedCoffeeOrders.setLoading();
    _ordersService.orders.addListener(_onOrdersReceived);
  }

  final OrdersService _ordersService;

  final _groupedCoffeeOrders =
      StatefulValueNotifier(GroupedCoffeeOrders.empty());

  StatefulValueListenable<GroupedCoffeeOrders> get groupedCoffeeOrders =>
      _groupedCoffeeOrders;

  void dispose() {
    _ordersService.orders.removeListener(_onOrdersReceived);
  }

  void onOrderStatusChange(String orderId, [CoffeeMakerStep? newStep]) {
    _ordersService.updateOrder(orderId, newStep);
  }

  void _onOrdersReceived() {
    final orders = _ordersService.orders.value;
    _groupedCoffeeOrders.setError(Exception('No orders available'));
  }

  bool orderExists(String orderId, CoffeeMakerStep step) {
    return _ordersService.orders.value
        .any((order) => order.id == orderId && order.coffeeMakerStep == step);
  }
}
