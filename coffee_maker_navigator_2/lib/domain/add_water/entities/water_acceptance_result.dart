sealed class WaterAcceptanceResult {
  final bool isAccepted;
  final String message;

  WaterAcceptanceResult({
    required this.isAccepted,
    required this.message,
  });
}

class WaterAcceptanceSuccess extends WaterAcceptanceResult {
  WaterAcceptanceSuccess()
      : super(
          isAccepted: true,
          message: 'Water condition is accepted',
        );
}

abstract class WaterAcceptanceFailure extends WaterAcceptanceResult {
  WaterAcceptanceFailure(String message)
      : super(
          isAccepted: false,
          message: message,
        );
}

class WaterQuantityFailure extends WaterAcceptanceFailure {
  WaterQuantityFailure() : super('Water quantity must be at least 100 ml');
}

class TemperatureFailure extends WaterAcceptanceFailure {
  TemperatureFailure(String message) : super(message);
}

class SourceFailure extends WaterAcceptanceFailure {
  SourceFailure() : super('Water source must be filtered unless over 500 ml');
}

class SeasonalTemperatureAdjustmentFailure extends WaterAcceptanceFailure {
  SeasonalTemperatureAdjustmentFailure(String message) : super(message);
}

class QualityCheckFailure extends WaterAcceptanceFailure {
  QualityCheckFailure()
      : super('Failed water quality check for specified source');
}
