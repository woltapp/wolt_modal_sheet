import 'package:wolt_di/wolt_di.dart';
import 'package:coffee_maker_navigator_2/features/orders/di/orders_dependency_container.dart';
import 'package:coffee_maker_navigator_2/features/add_water/domain/add_water_service.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/orders_service.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view_model/add_water_view_model.dart';

class AddWaterDependencyContainer
    extends FeatureWithViewModelDependencyContainer {
  // Just in the sake to show that we can use a method here to make the service lazily initialized.
  late final AddWaterService _addWaterService = _createAddWaterService();
  // This is an example to non-lazy initialization.
  late final OrdersService _ordersService;

  AddWaterDependencyContainer() {
    final orderDependencies = bindWith<OrdersDependencyContainer>();
    _ordersService = orderDependencies.ordersService;
  }

  AddWaterService _createAddWaterService() {
    return AddWaterService();
  }

  @override
  AddWaterViewModel createViewModel() => AddWaterViewModel(
        addWaterService: _addWaterService,
        ordersService: _ordersService,
      );

  @override
  void dispose() {
    // Only unbind, without disposing OrdersDependencyContainer, because we are using but not owning.
    // DependencyContainerManager will take care of disposing it if needed.
    unbindFrom<OrdersDependencyContainer>();
  }
}
