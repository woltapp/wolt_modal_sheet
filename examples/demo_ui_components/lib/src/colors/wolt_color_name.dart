import 'dart:ui';

import 'package:demo_ui_components/src/colors/wolt_colors.dart';

enum WoltColorName {
  white(
    color100: WoltColors.white,
    color64: WoltColors.white64,
    color48: WoltColors.white48,
    color16: WoltColors.white16,
    color8: WoltColors.white8,
  ),
  black(
    color100: WoltColors.black,
    color64: WoltColors.black64,
    color48: WoltColors.black48,
    color16: WoltColors.black16,
    color8: WoltColors.black8,
  ),
  red(
    color100: WoltColors.red,
    color64: WoltColors.red64,
    color48: WoltColors.red48,
    color16: WoltColors.red16,
    color8: WoltColors.red8,
  ),
  blue(
    color100: WoltColors.blue,
    color64: WoltColors.blue64,
    color48: WoltColors.blue48,
    color16: WoltColors.blue16,
    color8: WoltColors.blue8,
  ),
  green(
    color100: WoltColors.green,
    color64: WoltColors.green64,
    color48: WoltColors.green48,
    color16: WoltColors.green16,
    color8: WoltColors.green8,
  );

  const WoltColorName({
    required this.color100,
    required this.color64,
    required this.color48,
    required this.color16,
    required this.color8,
  });

  final Color color100;
  final Color color64;
  final Color color48;
  final Color color16;
  final Color color8;
}
