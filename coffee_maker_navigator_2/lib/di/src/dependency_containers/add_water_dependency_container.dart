import 'package:coffee_maker_navigator_2/di/src/framework/dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/src/dependency_containers/orders_dependency_container.dart';
import 'package:coffee_maker_navigator_2/domain/add_water/add_water_service.dart';
import 'package:coffee_maker_navigator_2/domain/orders/orders_service.dart';
import 'package:coffee_maker_navigator_2/ui/add_water/view_model/add_water_view_model.dart';

class AddWaterDependencyContainer extends FeatureLevelDependencyContainer {
  // Just in the sake to show that we can use a method here to make the service lazily initialized.
  late final AddWaterService _addWaterService = _createAddWaterService();
  // This is an example to non-lazy initialization.
  late final OrdersService _ordersService;

  AddWaterDependencyContainer({required super.resolver}) {
    final orderDependencies = bindWith<OrdersDependencyContainer>();
    _ordersService = orderDependencies.ordersService;
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
    // Only unbind, without disposing OrdersDependencyContainer, because we are using but not owning.
    // DependencyContainerManager will take care of disposing it if needed.
    unbindFrom<OrdersDependencyContainer>();
  }
}
