import 'package:coffee_maker_navigator_2/features/orders/data/remote/orders_remote_data_source.dart';
import 'package:coffee_maker_navigator_2/features/orders/data/repository/orders_repository.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/orders_service.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view_model/orders_screen_view_model.dart';
import 'package:wolt_di/wolt_di.dart';

class OrdersDependencyContainer
    extends FeatureWithViewModelDependencyContainer {
  late final OrdersRemoteDataSource _ordersRemoteDataSource;
  late final OrdersRepository _ordersRepository;
  late final OrdersService _ordersService;

  /// This is an example of exposing a getter for the use of other dependency containers.
  /// [AddWaterDependencyContainer] binds with [OrdersDependencyContainer] and uses this getter.
  OrdersService get ordersService => _ordersService;

  OrdersDependencyContainer() {
    _ordersRemoteDataSource = OrdersRemoteDataSourceImpl();
    _ordersRepository = OrdersRepository(
      ordersRemoteDataSource: _ordersRemoteDataSource,
    );
    _ordersService = OrdersService(ordersRepository: _ordersRepository);
  }

  @override
  OrdersScreenViewModel createViewModel() {
    return OrdersScreenViewModel(ordersService: _ordersService);
  }

  @override
  void dispose() {
    _ordersRemoteDataSource.dispose();
  }
}
