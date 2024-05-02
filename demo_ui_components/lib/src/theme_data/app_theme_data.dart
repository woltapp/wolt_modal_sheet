import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeData {
  static const navigationDrawerIconSize = 24.0;
  static const cornerRadiusLg = 12.0;
  static const cardBorderRadius =
      BorderRadius.all(Radius.circular(cornerRadiusLg));
  static final colorScheme =
      ColorScheme.fromSeed(seedColor: WoltColors.blue).copyWith(
    background: const Color(0xFFF6F6F6),
  );

  const AppThemeData();

  static ThemeData themeData(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme(Theme.of(context).textTheme);

    return ThemeData(
      brightness: colorScheme.brightness,
      indicatorColor: Colors.transparent,
      scaffoldBackgroundColor: colorScheme.background,
      textTheme: textTheme,
      cardTheme: _cardThemeData,
      outlinedButtonTheme: _outlinedButtonThemeData(textTheme),
      navigationBarTheme: _navigationBarThemeData(textTheme),
      useMaterial3: true,
      colorScheme: colorScheme,
    );
  }

  static NavigationBarThemeData _navigationBarThemeData(TextTheme textTheme) {
    return NavigationBarThemeData(
      height: 56.0,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      labelTextStyle: MaterialStateProperty.resolveWith(
        (state) {
          return state.contains(MaterialState.selected)
              ? textTheme.labelSmall!.copyWith(color: colorScheme.primary)
              : textTheme.labelSmall!;
        },
      ),
      iconTheme: MaterialStateProperty.resolveWith((state) {
        const iconSize = 24.0;

        return state.contains(MaterialState.selected)
            ? IconThemeData(size: iconSize, color: colorScheme.primary)
            : IconThemeData(size: iconSize, color: colorScheme.onSurface);
      }),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );
  }

  static OutlinedButtonThemeData _outlinedButtonThemeData(TextTheme textTheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        foregroundColor: WoltColors.black,
        backgroundColor: WoltColors.white,
        surfaceTintColor: WoltColors.white,
        fixedSize: const Size.fromHeight(36),
        padding: const EdgeInsets.all(12),
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide.none,
      ),
    );
  }

  static CardTheme get _cardThemeData {
    return CardTheme(
      color: colorScheme.surface,
      shadowColor: colorScheme.shadow,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: cardBorderRadius),
    );
  }
}
