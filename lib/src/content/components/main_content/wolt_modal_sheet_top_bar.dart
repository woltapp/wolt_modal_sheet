import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WoltModalSheetTopBar extends StatelessWidget {
  final WoltModalSheetPage page;

  const WoltModalSheetTopBar({required this.page, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeData = theme.extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    final elevation = themeData?.topBarElevation ?? defaultThemeData.topBarElevation;
    final shadowColor = themeData?.topBarShadowColor ??
        (theme.brightness == Brightness.light ? const Color(0xFFE4E4E4) : const Color(0xFF121212));
    final topBarHeight = page.navBarHeight ??
        themeData?.navBarHeight ??
        defaultThemeData.navBarHeight;
    final backgroundColor =
        page.backgroundColor ?? themeData?.backgroundColor ?? defaultThemeData.backgroundColor;
    final surfaceTintColor = themeData?.surfaceTintColor ?? defaultThemeData.surfaceTintColor;
    return Column(
      children: [
        Material(
          type: MaterialType.canvas,
          color: backgroundColor,
          surfaceTintColor: surfaceTintColor,
          shadowColor: shadowColor,
          elevation: elevation,
          child: SizedBox(height: topBarHeight - elevation, width: double.infinity),
        ),
        SizedBox(height: elevation),
      ],
    );
  }
}
