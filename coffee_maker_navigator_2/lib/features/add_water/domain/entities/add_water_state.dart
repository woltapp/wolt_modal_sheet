import 'package:coffee_maker_navigator_2/features/add_water/domain/entities/water_source.dart';

class AddWaterState {
  final String waterQuantityInMl;
  final String waterTemperatureInC;
  final WaterSource waterSource;
  final bool isReadyToAddWater;
  final String? errorMessage;

  const AddWaterState({
    this.waterQuantityInMl = '',
    this.waterTemperatureInC = '',
    this.waterSource = WaterSource.tap,
    this.isReadyToAddWater = false,
    this.errorMessage,
  });

  static AddWaterState empty() => const AddWaterState();

  AddWaterState withQuantity(String quantity) => AddWaterState(
        waterQuantityInMl: quantity,
        waterTemperatureInC: waterTemperatureInC,
        waterSource: waterSource,
        isReadyToAddWater: isReadyToAddWater,
      );

  AddWaterState withTemperature(String temperature) => AddWaterState(
        waterQuantityInMl: waterQuantityInMl,
        waterTemperatureInC: temperature,
        waterSource: waterSource,
        isReadyToAddWater: isReadyToAddWater,
      );

  AddWaterState withWaterSource(WaterSource source) => AddWaterState(
        waterQuantityInMl: waterQuantityInMl,
        waterTemperatureInC: waterTemperatureInC,
        waterSource: source,
        isReadyToAddWater: isReadyToAddWater,
      );

  AddWaterState withValidationResult({
    required bool isReady,
    String? error,
  }) =>
      AddWaterState(
        waterQuantityInMl: waterQuantityInMl,
        waterTemperatureInC: waterTemperatureInC,
        waterSource: waterSource,
        isReadyToAddWater: isReady,
        errorMessage: error,
      );
}
