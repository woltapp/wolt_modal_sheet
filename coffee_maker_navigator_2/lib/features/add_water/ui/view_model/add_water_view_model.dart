import 'package:coffee_maker_navigator_2/features/add_water/domain/add_water_service.dart';
import 'package:coffee_maker_navigator_2/features/add_water/domain/entities/water_source.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/orders_service.dart';
import 'package:wolt_state_management/wolt_state_management.dart';

class AddWaterViewModel {
  AddWaterViewModel({
    required AddWaterService addWaterService,
    required OrdersService ordersService,
  })  : _addWaterService = addWaterService,
        _ordersService = ordersService {
    _waterQuantity.setIdle(value: '');
    _waterTemperature.setIdle(value: '');
    _waterSource.setIdle(value: WaterSource.tap);
    _isReadyToAddWater.setIdle(value: false);
    _errorMessage.setIdle(value: null);
  }

  final AddWaterService _addWaterService;
  final OrdersService _ordersService;
  late String _orderId;

  final _waterQuantity = StatefulValueNotifier<String>.idle('');
  final _waterTemperature = StatefulValueNotifier<String>.idle('');
  final _waterSource = StatefulValueNotifier<WaterSource>.idle(WaterSource.tap);
  final _isReadyToAddWater = StatefulValueNotifier<bool>.idle(false);
  final _errorMessage = StatefulValueNotifier<String?>.idle(null);

  StatefulValueListenable<String> get waterQuantity => _waterQuantity;
  StatefulValueListenable<String> get waterTemperature => _waterTemperature;
  StatefulValueListenable<WaterSource> get waterSource => _waterSource;
  StatefulValueListenable<bool> get isReadyToAddWater => _isReadyToAddWater;
  StatefulValueListenable<String?> get errorMessage => _errorMessage;

  bool get orderExists {
    return _ordersService.orders.value.any(
      (order) => order.id == _orderId && order.coffeeMakerStep == CoffeeMakerStep.addWater,
    );
  }

  void onInit(String orderId) {
    _orderId = orderId;
  }

  void updateWaterQuantity(String quantity) {
    _waterQuantity.setIdle(value: quantity);
  }

  void updateWaterTemperature(String temperature) {
    _waterTemperature.setIdle(value: temperature);
  }

  void updateWaterSource(WaterSource source) {
    _waterSource.setIdle(value: source);
  }

  void validateForm() {
    final quantity = _waterQuantity.value.value ?? '';
    final temperature = _waterTemperature.value.value ?? '';

    if (quantity.isEmpty || temperature.isEmpty) {
      _isReadyToAddWater.setIdle(value: false);
      _errorMessage.setIdle(value: 'Please fill in all fields');
      return;
    }

    try {
      final quantityValue = double.parse(quantity);
      final temperatureValue = double.parse(temperature);

      if (quantityValue <= 0 || temperatureValue <= 0) {
        _isReadyToAddWater.setIdle(value: false);
        _errorMessage.setIdle(value: 'Values must be greater than 0');
        return;
      }

      final result = _addWaterService.checkWaterAcceptance(
        waterQuantityInMl: quantityValue,
        waterTemperatureInC: temperatureValue,
        waterSource: _waterSource.value.value ?? WaterSource.tap,
        currentDate: DateTime.now(),
      );

      _isReadyToAddWater.setIdle(value: result.isAccepted);
      _errorMessage.setIdle(value: result.isAccepted ? null : result.message);
    } catch (e) {
      _isReadyToAddWater.setIdle(value: false);
      _errorMessage.setIdle(value: 'Please enter valid numbers');
    }
  }

  void onAddWaterPressed() {
    _ordersService.updateOrder(_orderId, CoffeeMakerStep.ready);
  }

  void dispose() {
    _waterQuantity.dispose();
    _waterTemperature.dispose();
    _waterSource.dispose();
    _isReadyToAddWater.dispose();
    _errorMessage.dispose();
  }
}
