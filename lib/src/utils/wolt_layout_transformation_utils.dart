import 'dart:math';

class WoltLayoutTransformationUtils {
  WoltLayoutTransformationUtils._();

  static double calculateTransformationValue({
    required double rangeInPx,
    required double progressInRangeInPx,
    required double startValue,
    required double endValue,
  }) {
    final progress = progressInRangeInPx / rangeInPx;
    final rawValue = startValue + (progress * (endValue - startValue));
    return rawValue.clamp(min(startValue, endValue), max(startValue, endValue));
  }
}
