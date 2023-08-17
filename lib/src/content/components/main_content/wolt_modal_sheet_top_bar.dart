import 'package:flutter/material.dart';

class WoltModalSheetTopBar extends StatelessWidget {
  /// The height of the top bar, defined by the user.
  final double topBarHeight;

  /// The color of the top bar, defined by the user.
  final Color topBarColor;

  /// Creates an instance of `WoltModalSheetTopBar`.
  ///
  /// Both `topBarColor` and `topBarHeight` must be non-null.
  const WoltModalSheetTopBar({
    required this.topBarColor,
    required this.topBarHeight,
    Key? key,
  }) : super(key: key);

  // TODO: get this information from ThemeData extensions
  /// Constant elevation value that gives the top bar a raised appearance.
  static const _elevation = 1.0;

  // TODO: get this information from ThemeData extensions
  /// The color for the elevation effect, typically a shade that contrasts with `topBarColor`.
  static const _elevationColor = Color(0xFFE4E4E4);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: topBarHeight - _elevation, color: topBarColor),
        const ColoredBox(
          color: _elevationColor,
          child: SizedBox(height: _elevation, width: double.infinity),
        ),
      ],
    );
  }
}
