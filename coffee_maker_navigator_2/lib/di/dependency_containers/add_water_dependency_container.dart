import 'package:coffee_maker_navigator_2/di/dependency_containers/dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/orders_dependency_container.dart';
import 'package:coffee_maker_navigator_2/domain/add_water/add_water_service.dart';
import 'package:coffee_maker_navigator_2/domain/orders/orders_service.dart';
import 'package:coffee_maker_navigator_2/ui/add_water/view_model/add_water_view_model.dart';

class AddWaterDependencyContainer extends LocalDependencyContainer {
  // Just in the sake to show that we can use a method here and keep lazyness.
  late final AddWaterService _addWaterService = _createAddWaterService();
  late final OrdersService _ordersService;

  AddWaterDependencyContainer({required super.resolver}) {
    // _addWaterService = AddWaterService();// Cagatay: why can't we make it lazy.
    // Mikhail: How to make sure that this is singleton in DI?
    // It is also initialized in the previous container. Should we separate UI container and Data
    // container? Because the Data container is reused.
    final orderDeps = bindWith<OrdersDependencyContainer>();
    _ordersService = orderDeps.ordersService;
  }

  AddWaterViewModel createViewModel() {
    return AddWaterViewModel(
      addWaterService: _addWaterService,
      ordersService: _ordersService,
    );
  }

  AddWaterService _createAddWaterService() {
    return AddWaterService();
  }

  @override
  void dispose() {
    unbindFrom<OrdersDependencyContainer>();
    // Cagatay: seems dispose need (or not, based on implementation).
    // _addWaterService.dispose();
  }
}
