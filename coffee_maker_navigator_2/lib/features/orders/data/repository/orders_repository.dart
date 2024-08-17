import 'package:coffee_maker_navigator_2/features/orders/data/remote/orders_remote_data_source.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_order.dart';

import 'package:flutter/foundation.dart';

class OrdersRepository {
  final OrdersRemoteDataSource _ordersRemoteDataSource;

  OrdersRepository({required OrdersRemoteDataSource ordersRemoteDataSource})
      : _ordersRemoteDataSource = ordersRemoteDataSource;

  ValueListenable<List<CoffeeOrder>> receiveOrders() {
    return _ordersRemoteDataSource.receiveOrders();
  }

  Future<CoffeeOrder?> updateOrder(CoffeeOrder order) async {
    return await _ordersRemoteDataSource.updateOrder(order);
  }

  Future<void> archiveOrder(String id) async {
    return await _ordersRemoteDataSource.archiveOrder(id);
  }
}
