import 'package:coffee_maker_navigator_2/data/orders/remote/orders_remote_data_source.dart';
import 'package:coffee_maker_navigator_2/domain/orders/entities/coffee_order.dart';
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
