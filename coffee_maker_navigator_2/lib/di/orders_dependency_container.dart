import 'package:coffee_maker_navigator_2/data/orders/remote/orders_remote_data_source.dart';
import 'package:coffee_maker_navigator_2/data/orders/repository/orders_repository.dart';
import 'package:coffee_maker_navigator_2/domain/orders/orders_service.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view_model/orders_screen_view_model.dart';
import 'package:wolt_di/wolt_di.dart';

class OrdersDependencyContainer extends FeatureLevelDependencyContainer {
  late final OrdersRemoteDataSource _ordersRemoteDataSource;
  late final OrdersRepository _ordersRepository;
  late final OrdersService _ordersService;

  OrdersService get ordersService => _ordersService;

  OrdersDependencyContainer() {
    _ordersRemoteDataSource = OrdersRemoteDataSourceImpl();
    _ordersRepository = OrdersRepository(
      ordersRemoteDataSource: _ordersRemoteDataSource,
    );
    _ordersService = OrdersService(ordersRepository: _ordersRepository);
  }

  OrdersScreenViewModel createOrderScreenViewModel() {
    return OrdersScreenViewModel(ordersService: _ordersService);
  }

  @override
  void dispose() {
    _ordersRemoteDataSource.dispose();
  }
}
