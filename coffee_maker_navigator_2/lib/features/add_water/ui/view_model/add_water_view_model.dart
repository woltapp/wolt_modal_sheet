import 'package:coffee_maker_navigator_2/features/add_water/domain/add_water_service.dart';
import 'package:coffee_maker_navigator_2/features/add_water/domain/entities/add_water_state.dart';
import 'package:coffee_maker_navigator_2/features/add_water/domain/entities/water_source.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/orders_service.dart';
import 'package:wolt_state_management/wolt_state_management.dart';

class AddWaterViewModel {
  final AddWaterService _addWaterService;
  final OrdersService _ordersService;
  late String _orderId;

  final _addWaterState = StatefulValueNotifier.idle(AddWaterState.empty());

  StatefulValueListenable<AddWaterState> get addWaterState => _addWaterState;

  bool get orderExists {
    return _ordersService.orders.value.any(
      (order) => order.id == _orderId && order.coffeeMakerStep == CoffeeMakerStep.addWater,
    );
  }

  AddWaterViewModel({
    required AddWaterService addWaterService,
    required OrdersService ordersService,
  })  : _addWaterService = addWaterService,
        _ordersService = ordersService;

  void onInit(String orderId) {
    _orderId = orderId;
  }

  void onWaterQuantityUpdated(String value) {
    final currentState = _addWaterState.value.value ?? AddWaterState.empty();
    _addWaterState.setIdle(value: currentState.withQuantity(value));
  }

  void onWaterTemperatureUpdated(String value) {
    final currentState = _addWaterState.value.value ?? AddWaterState.empty();
    _addWaterState.setIdle(value: currentState.withTemperature(value));
  }

  void onWaterSourceUpdated(WaterSource value) {
    final currentState = _addWaterState.value.value ?? AddWaterState.empty();
    _addWaterState.setIdle(value: currentState.withWaterSource(value));
  }

  void onCheckValidityPressed() {
    final currentState = _addWaterState.value.value ?? AddWaterState.empty();
    double? quantity = double.tryParse(currentState.waterQuantityInMl);
    double? temperature = double.tryParse(currentState.waterTemperatureInC);

    if (quantity == null || temperature == null) {
      _addWaterState.setIdle(
        value: currentState.withValidationResult(
          isReady: false,
          error: "Invalid numeric values for quantity or temperature.",
        ),
      );
      return;
    }

    final result = _addWaterService.checkWaterAcceptance(
      waterQuantityInMl: quantity,
      waterTemperatureInC: temperature,
      waterSource: currentState.waterSource,
      currentDate: DateTime.now(),
    );

    _addWaterState.setIdle(
      value: currentState.withValidationResult(
        isReady: result.isAccepted,
        error: result.isAccepted ? null : result.message,
      ),
    );
  }

  void onAddWaterPressed() {
    _ordersService.updateOrder(_orderId, CoffeeMakerStep.ready);
  }

  void dispose() {
    _addWaterState.dispose();
  }
}
