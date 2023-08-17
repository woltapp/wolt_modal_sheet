import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_page/wolt_modal_sheet_page.dart';

class WoltModalSheetTopBar extends StatelessWidget {
  final WoltModalSheetPage page;

  const WoltModalSheetTopBar({required this.page, Key? key}) : super(key: key);

  // TODO: get this information from ThemeData extensions
  /// Constant elevation value that gives the top bar a raised appearance.
  static const _elevation = 1.0;

  // TODO: get this information from ThemeData extensions
  /// The color for the elevation effect, typically a shade that contrasts with `topBarColor`.
  static const _shadowColor = Color(0xFFE4E4E4);

  @override
  Widget build(BuildContext context) {
    final topBarHeight = page.navigationBarHeight;
    final backgroundColor = page.backgroundColor;

    return Column(
      children: [
        Material(
          type: MaterialType.canvas,
          color: backgroundColor,
          shadowColor: _shadowColor,
          elevation: _elevation,
          child: SizedBox(height: topBarHeight - _elevation, width: double.infinity),
        ),
        const SizedBox(height: _elevation),
      ],
    );
  }
}
