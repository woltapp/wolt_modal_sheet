import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_page/wolt_modal_sheet_page.dart';

/// A widget that wraps the Sticky Action Bar in the [WoltModalSheetPage].
///
/// It handles the conditional rendering of the Sticky Action Bar and the
/// gradient overlay above it, based on the configurations provided in the [WoltModalSheetPage].
class WoltStickyActionBarWrapper extends StatelessWidget {
  /// Constructs a `WoltStickyActionBarWrapper`.
  ///
  /// The [page] argument must not be null.
  const WoltStickyActionBarWrapper({required this.page, Key? key}) : super(key: key);

  /// The [WoltModalSheetPage] which provides configuration for the Sticky Action Bar
  /// and potentially its gradient overlay.
  final WoltModalSheetPage page;

  @visibleForTesting
  static const gradientWidgetKey = ValueKey("WoltStickyActionBarWrapperGradient");

  @override
  Widget build(BuildContext context) {
    // Fetch the sticky action bar from the provided page
    final stickyActionBar = page.stickyActionBar;

    // If there's no action bar provided, render nothing.
    if (stickyActionBar == null) {
      return const SizedBox.shrink();
    }

    // The background color for the sticky action bar and potentially its gradient overlay.
    final backgroundColor = page.backgroundColor;

    // Render a Column widget containing the sticky action bar
    // and its gradient overlay if needed.
    return Column(
      children: [
        // If a gradient is required, add a Container with a linear gradient decoration.
        if (page.hasSabGradient)
          Container(
            key: gradientWidgetKey,
            /// TODO(ulusoyca): get the gradient height value from the theme extensions
            height: 24.0,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  backgroundColor,
                  backgroundColor.withOpacity(0),
                ],
              ),
            ),
          ),
        // Render the sticky action bar with its background color.
        ColoredBox(color: backgroundColor, child: stickyActionBar),
      ],
    );
  }
}
