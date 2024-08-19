import 'package:coffee_maker_navigator_2/features/orders/data/remote/orders_remote_data_source.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_order.dart';

class OrdersRepository {
  final OrdersRemoteDataSource _ordersRemoteDataSource;

  OrdersRepository({required OrdersRemoteDataSource ordersRemoteDataSource})
      : _ordersRemoteDataSource = ordersRemoteDataSource;

  Future<List<CoffeeOrder>> fetchOrders() async {
    return await _ordersRemoteDataSource.fetchOrders();
  }

  Future<CoffeeOrder?> updateOrder(CoffeeOrder order) async {
    return await _ordersRemoteDataSource.updateOrder(order);
  }

  Future<void> archiveOrder(String id) async {
    return await _ordersRemoteDataSource.archiveOrder(id);
  }
}
