import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// Top bar widget used in a [WoltModalSheetPage].
///
/// If [WoltModalSheetPage.topBar] is provided, this widget wraps it with a shadow and elevation
/// as specified by the theme or defaults. In the absence of a [WoltModalSheetPage.topBar], this
/// widget creates a default top bar styled with the appropriate theme settings.
///
/// The widget respects the modal sheet's page settings, such as [WoltModalSheetPage.navBarHeight]
/// and [WoltModalSheetPage.backgroundColor]. It also respects custom theme settings through
/// [WoltModalSheetThemeData] while falling back to [WoltModalSheetDefaultThemeData] for default
/// theming values.
class WoltModalSheetTopBar extends StatelessWidget {
  /// The modal sheet page that contains the configuration and content settings.
  final SliverWoltModalSheetPage page;

  /// Creates a new instance of [WoltModalSheetTopBar].
  const WoltModalSheetTopBar({required this.page, super.key});

  @override
  Widget build(BuildContext context) {
    // Obtain the current theme and modal sheet-specific theme settings.
    final theme = Theme.of(context);
    final themeData = theme.extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);

    // Determine the top bar's elevation, shadow color, height, background color, and surface tint color.
    final elevation =
        themeData?.topBarElevation ?? defaultThemeData.topBarElevation;
    final shadowColor = themeData?.topBarShadowColor ??
        (theme.brightness == Brightness.light
            ? const Color(0xFFE4E4E4)
            : const Color(0xFF121212));
    final topBarHeight = page.navBarHeight ??
        themeData?.navBarHeight ??
        defaultThemeData.navBarHeight;
    final backgroundColor = page.backgroundColor ??
        themeData?.backgroundColor ??
        defaultThemeData.backgroundColor;
    final surfaceTintColor = page.surfaceTintColor ??
        themeData?.surfaceTintColor ??
        defaultThemeData.surfaceTintColor;

    // Create the default top bar widget.
    SizedBox topBarWidget = SizedBox(
      height: topBarHeight - elevation,
      width: double.infinity,
    );

    // If page.topBar is not null, then wrap it in the default top bar widget.
    if (page.topBar != null) {
      topBarWidget = SizedBox(
        height: topBarHeight - elevation,
        width: double.infinity,
        child: page.topBar,
      );
    }

    return Column(
      children: [
        Material(
          type: MaterialType.canvas,
          color: backgroundColor,
          surfaceTintColor: surfaceTintColor,
          shadowColor: shadowColor,
          elevation: elevation,
          child: topBarWidget,
        ),
        SizedBox(height: elevation),
      ],
    );
  }
}
