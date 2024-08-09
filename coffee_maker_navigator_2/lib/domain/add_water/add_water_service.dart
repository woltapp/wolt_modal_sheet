import 'package:coffee_maker_navigator_2/domain/add_water/entities/coffee_season.dart';
import 'package:coffee_maker_navigator_2/domain/add_water/entities/water_acceptance_result.dart';
import 'package:coffee_maker_navigator_2/domain/add_water/entities/water_source.dart';

class AddWaterService {
  // We keep the business logic in client without any data source layer operations.
  AddWaterService();

  WaterAcceptanceResult checkWaterAcceptance({
    required double waterQuantityInMl,
    required double waterTemperatureInC,
    required WaterSource waterSource,
    required DateTime currentDate,
  }) {
    if (waterQuantityInMl < 100) {
      return WaterQuantityFailure();
    }

    CoffeeSeason currentSeason =
        CoffeeSeason.determineCurrentSeason(currentDate);

    final temperatureResult = _checkTemperatureValidity(
      waterTemperatureInC,
      waterSource,
      currentSeason,
    );

    if (!temperatureResult.isAccepted) {
      return SeasonalTemperatureAdjustmentFailure(temperatureResult.message);
    }

    if (!_isWaterSourceValidForQuantity(waterSource, waterQuantityInMl)) {
      return SourceFailure();
    }

    if (!_isQualityValid(waterSource)) {
      return QualityCheckFailure();
    }

    return WaterAcceptanceSuccess();
  }

  bool _isWaterSourceValidForQuantity(
      WaterSource waterSource, double waterQuantityInMl) {
    return !(waterSource == WaterSource.filtered && waterQuantityInMl <= 500);
  }

  WaterAcceptanceResult _checkTemperatureValidity(
    double temperature,
    WaterSource source,
    CoffeeSeason season,
  ) {
    final minWaterTemp = season.minWaterTemperatureForCoffee;
    final maxWaterTemp = season.maxWaterTemperatureForCoffee;
    if (temperature >= minWaterTemp && temperature <= maxWaterTemp) {
      return WaterAcceptanceSuccess();
    } else {
      return TemperatureFailure(
        'Water temperature should be between $minWaterTemp°C and $maxWaterTemp°C during ${season.label}.',
      );
    }
  }

  bool _isQualityValid(WaterSource source) {
    // Reject water if pH is outside the ideal range for coffee
    return !(source.phLevel < 6.5 || source.phLevel > 8.5);
  }
}
