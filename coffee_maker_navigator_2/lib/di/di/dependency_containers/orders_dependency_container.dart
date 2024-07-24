import 'package:coffee_maker_navigator_2/data/orders/remote/orders_remote_data_source.dart';
import 'package:coffee_maker_navigator_2/data/orders/repository/orders_repository.dart';
import 'package:coffee_maker_navigator_2/di/di/dependency_containers/dependency_container.dart';
import 'package:coffee_maker_navigator_2/domain/orders/orders_service.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view_model/orders_screen_view_model.dart';

class OrdersDependencyContainer extends SyncDependencyContainer {
  late final OrdersRemoteDataSource _ordersRemoteDataSource;
  late final OrdersRepository _ordersRepository;
  late final OrdersService _ordersService;
  late final OrdersScreenViewModel _ordersViewModel;

  OrdersDependencyContainer();

  @override
  void init() {
    _ordersRemoteDataSource = OrdersRemoteDataSourceImpl();
    _ordersRepository =
        OrdersRepository(ordersRemoteDataSource: _ordersRemoteDataSource);
    _ordersService = OrdersService(ordersRepository: _ordersRepository);
  }

  OrdersScreenViewModel createOrderScreenViewModel() {
    return OrdersScreenViewModel(ordersService: _ordersService);
  }

  @override
  void dispose() {
    _ordersViewModel.dispose();
  }
}
