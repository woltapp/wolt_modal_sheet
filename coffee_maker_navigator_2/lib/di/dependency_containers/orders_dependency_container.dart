import 'package:coffee_maker_navigator_2/data/orders/remote/orders_remote_data_source.dart';
import 'package:coffee_maker_navigator_2/data/orders/repository/orders_repository.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/dependency_container.dart';
import 'package:coffee_maker_navigator_2/domain/orders/orders_service.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view_model/orders_screen_view_model.dart';

class OrdersDependencyContainer extends LocalDependencyContainer {
  late final OrdersRemoteDataSource _ordersRemoteDataSource;
  late final OrdersRepository _ordersRepository;
  late final OrdersService _ordersService;

  OrdersService get ordersService => _ordersService;

  OrdersDependencyContainer({required super.resolver}) {
    _ordersRemoteDataSource = OrdersRemoteDataSourceImpl();
    _ordersRepository = OrdersRepository(
      ordersRemoteDataSource: _ordersRemoteDataSource,
    );
    _ordersService = OrdersService(ordersRepository: _ordersRepository);
  }

  OrdersScreenViewModel createOrderScreenViewModel() {
    // Mikhail: How do we make sure that the onInit method calling is not forgotten?
    // From my point of view it is not responsibility of container to init view model.
    // It can be responsibility for container in case of owning the depenency,
    // but this one is factory. So we provide prepared entity, but then all management
    // on the owner - init, dispose, etc.
    return OrdersScreenViewModel(ordersService: _ordersService)..onInit();
  }

  @override
  void dispose() {
    // Cagatay: looks like disposing methods for OrdersRemoteDataSource,etc are
    // missed.
  }
}
