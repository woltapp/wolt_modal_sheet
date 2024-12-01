enum WaterSource {
  tap,
  filtered,
  bottled;

  String get label {
    switch (this) {
      case WaterSource.tap:
        return 'Tap water';
      case WaterSource.filtered:
        return 'Filtered water';
      case WaterSource.bottled:
        return 'Bottled water';
    }
  }
}
