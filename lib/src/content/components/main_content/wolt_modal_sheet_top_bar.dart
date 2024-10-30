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
  final double topBarHeight;
  final Widget? topBar;
  final Color? surfaceTintColor;
  final Color? backgroundColor;
  final Color? shadowColor;
  final double elevation;

  /// Creates a new instance of [WoltModalSheetTopBar].
  const WoltModalSheetTopBar({
    required this.topBarHeight,
    required this.topBar,
    required this.surfaceTintColor,
    required this.backgroundColor,
    required this.elevation,
    required this.shadowColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create the default top bar widget.
    SizedBox topBarWidget = SizedBox(
      height: topBarHeight - elevation,
      width: double.infinity,
    );

    // If page.topBar is not null, then wrap it in the default top bar widget.
    final topBar = this.topBar;
    if (topBar != null) {
      topBarWidget = SizedBox(
        height: topBarHeight - elevation,
        width: double.infinity,
        child: topBar,
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
