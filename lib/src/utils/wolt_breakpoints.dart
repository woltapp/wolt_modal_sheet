enum WoltBreakpoints {
  xsmall(minValue: 0, maxValue: 523.0),
  small(minValue: 524.0, maxValue: 767.0),
  medium(minValue: 768.0, maxValue: 1399.0),
  large(minValue: 1400.0, maxValue: double.infinity);

  const WoltBreakpoints({required this.maxValue, required this.minValue});

  final double maxValue;
  final double minValue;

  static WoltBreakpoints getScreenTypeForWidth(double screenWidth) {
    for (var screenType in WoltBreakpoints.values) {
      if (screenWidth >= screenType.minValue &&
          screenWidth <= screenType.maxValue) {
        return screenType;
      }
    }
    // Default to small if no match is found.
    return WoltBreakpoints.small;
  }
}
