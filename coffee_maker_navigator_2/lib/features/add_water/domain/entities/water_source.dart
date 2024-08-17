enum WaterSource {
  tap(phLevel: 7.5, hardness: 3.5),
  filtered(phLevel: 7.0, hardness: 2.0),
  bottled(phLevel: 6.5, hardness: 1.0);

  final double phLevel;
  final double hardness;

  const WaterSource({
    required this.phLevel,
    required this.hardness,
  });

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
