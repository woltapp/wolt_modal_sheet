import 'package:coffee_maker_navigator_2/data/orders/remote/orders_remote_data_source.dart';
import 'package:coffee_maker_navigator_2/data/orders/repository/orders_repository.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/dependency_container.dart';
import 'package:coffee_maker_navigator_2/domain/add_water/add_water_service.dart';
import 'package:coffee_maker_navigator_2/domain/orders/orders_service.dart';
import 'package:coffee_maker_navigator_2/ui/add_water/view_model/add_water_view_model.dart';

class AddWaterDependencyContainer extends SyncDependencyContainer {
  late final AddWaterService _addWaterService;
  late final AddWaterViewModel _addWaterViewModel;

  late final OrdersRemoteDataSource _ordersRemoteDataSource;
  late final OrdersRepository _ordersRepository;
  late final OrdersService _ordersService;

  AddWaterDependencyContainer();

  @override
  void init() {
    _addWaterService = AddWaterService();
    _ordersRemoteDataSource = OrdersRemoteDataSourceImpl();
    _ordersRepository =
        OrdersRepository(ordersRemoteDataSource: _ordersRemoteDataSource);
    _ordersService = OrdersService(ordersRepository: _ordersRepository);
    _ordersService = OrdersService(
      ordersRepository:
          OrdersRepository(ordersRemoteDataSource: _ordersRemoteDataSource),
    );
  }

  AddWaterViewModel createViewModel() {
    return AddWaterViewModel(
      addWaterService: _addWaterService,
      ordersService: _ordersService,
    );
  }

  @override
  void dispose() {
    _addWaterViewModel.dispose();
  }
}
