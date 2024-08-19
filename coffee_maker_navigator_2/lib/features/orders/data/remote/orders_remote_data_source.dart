import 'dart:async';

import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_order.dart';

abstract interface class OrdersRemoteDataSource {
  Future<List<CoffeeOrder>> fetchOrders();

  Future<CoffeeOrder> updateOrder(CoffeeOrder updatedOrder);

  Future<void> archiveOrder(String id);

  void dispose();
}

/// A data source that provides access to a list of coffee orders. This class is used to simulate
/// a remote data source. In a real-world scenario, this class would interact with a remote
/// server to fetch and update coffee orders.
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  OrdersRemoteDataSourceImpl();

  List<CoffeeOrder> _orders = List<CoffeeOrder>.from(_mockCoffeeOrders);

  @override
  Future<List<CoffeeOrder>> fetchOrders() {
    return Future.value(_orders);
  }

  @override
  Future<CoffeeOrder> updateOrder(CoffeeOrder updatedOrder) async {
    final orders = List<CoffeeOrder>.from(_orders);
    int index = orders.indexWhere((order) => order.id == updatedOrder.id);
    if (index != -1) {
      orders[index] = updatedOrder;
      _orders = orders;
      return updatedOrder;
    } else {
      throw Exception('Order not found');
    }
  }

  @override
  Future<void> archiveOrder(String id) async {
    final orders = List<CoffeeOrder>.from(_orders);
    orders.removeWhere((order) => order.id == id);
    _orders = orders;
  }

  @override
  void dispose() {
    _orders = <CoffeeOrder>[];
  }
}

/// A list of mock coffee orders used in the CoffeeMaker demo app.
const List<CoffeeOrder> _mockCoffeeOrders = <CoffeeOrder>[
  CoffeeOrder(
    coffeeMakerStep: CoffeeMakerStep.grind,
    orderName: 'Yuho W.',
    id: '#001',
  ),
  CoffeeOrder(
    coffeeMakerStep: CoffeeMakerStep.grind,
    orderName: 'John Doe',
    id: '#002',
  ),
  CoffeeOrder(
    coffeeMakerStep: CoffeeMakerStep.grind,
    orderName: 'Jane Smith',
    id: '#003',
  ),
  CoffeeOrder(
    coffeeMakerStep: CoffeeMakerStep.grind,
    orderName: 'Michael Johnson',
    id: '#004',
  ),
  CoffeeOrder(
    coffeeMakerStep: CoffeeMakerStep.grind,
    orderName: 'Sarah Davis',
    id: '#005',
  ),
  CoffeeOrder(
    coffeeMakerStep: CoffeeMakerStep.grind,
    orderName: 'David Wilson',
    id: '#006',
  ),
  CoffeeOrder(
    coffeeMakerStep: CoffeeMakerStep.addWater,
    orderName: 'Emily Brown',
    id: '#007',
  ),
  CoffeeOrder(
    coffeeMakerStep: CoffeeMakerStep.addWater,
    orderName: 'Robert Jones',
    id: '#008',
  ),
  CoffeeOrder(
    coffeeMakerStep: CoffeeMakerStep.ready,
    orderName: 'Jennifer Taylor',
    id: '#009',
  ),
];
