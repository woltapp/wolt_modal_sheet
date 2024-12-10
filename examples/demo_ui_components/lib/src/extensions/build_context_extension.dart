import 'package:flutter/material.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

/// An extension class for the `BuildContext` to provide screen size information that corresponds
/// to [WoltScreenSize].
extension BuiltContextExtensionForWoltScreenSize on BuildContext {
  /// Retrieves the screen size based on the width of the current media query.
  ///
  /// The screen size is determined by comparing the width of the current media query with a
  /// breakpoint of [WoltScreenWidthAdaptiveWidget.defaultWidthBreakPoint].
  /// If the width is less than [WoltScreenWidthAdaptiveWidget.defaultWidthBreakPoint], it returns `WoltScreenSize.small`.
  /// Otherwise, it returns `WoltScreenSize.large`.
  WoltScreenSize get screenSize {
    var screenWidth = MediaQuery.sizeOf(this).width;
    return screenWidth < WoltScreenWidthAdaptiveWidget.defaultWidthBreakPoint
        ? WoltScreenSize.small
        : WoltScreenSize.large;
  }
}
