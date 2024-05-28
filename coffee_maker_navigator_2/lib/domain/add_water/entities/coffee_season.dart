enum CoffeeSeason {
  spring(minWaterTemperatureForCoffee: 20, maxWaterTemperatureForCoffee: 30),
  summer(minWaterTemperatureForCoffee: 22, maxWaterTemperatureForCoffee: 30),
  autumn(minWaterTemperatureForCoffee: 20, maxWaterTemperatureForCoffee: 28),
  winter(minWaterTemperatureForCoffee: 18, maxWaterTemperatureForCoffee: 25);

  final double minWaterTemperatureForCoffee;
  final double maxWaterTemperatureForCoffee;

  const CoffeeSeason({
    required this.minWaterTemperatureForCoffee,
    required this.maxWaterTemperatureForCoffee,
  });

  String get label {
    switch (this) {
      case CoffeeSeason.spring:
        return 'spring';
      case CoffeeSeason.summer:
        return 'summer';
      case CoffeeSeason.autumn:
        return 'autumn';
      case CoffeeSeason.winter:
        return 'winter';
    }
  }

  static CoffeeSeason determineCurrentSeason(DateTime date) {
    final month = date.month;
    if (month >= 3 && month <= 5) {
      return CoffeeSeason.spring;
    } else if (month >= 6 && month <= 8) {
      return CoffeeSeason.summer;
    } else if (month >= 9 && month <= 11) {
      return CoffeeSeason.autumn;
    } else {
      return CoffeeSeason.winter;
    }
  }
}
