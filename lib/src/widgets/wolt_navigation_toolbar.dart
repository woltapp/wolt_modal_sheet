import 'dart:math';

import 'package:flutter/material.dart';

/// [WoltNavigationToolbar] is a modified version of the [NavigationToolbar] widget in the
/// Flutter SDK. The primary modification is in the [performLayout] method of the
/// [_ToolbarLayout] class.
///
/// This modification ensures a symmetric layout of widgets in the absence of either
/// a leading or trailing widget, which makes for a visually balanced and
/// aesthetically pleasing user interface.
///
/// This widget lays out its children in a manner suitable for a toolbar and
/// positions three widgets or groups of widgets along a horizontal axis that's
/// sensible for an application's navigation bar such as in Material Design and in iOS.
///
/// The [leading] and [trailing] widgets occupy the edges of the widget with
/// reasonable size constraints while the [middle] widget occupies the remaining
/// space in either a center aligned or start aligned fashion.
///
/// Modifications in [performLayout] ensure that if there is no leading widget and
/// there is a trailing widget, then the width of the trailing widget is used as the
/// width of the leading widget. Similarly, if there is no trailing widget and
/// there is a leading widget, then the width of the leading widget is used as the
/// width of the trailing widget.
class WoltNavigationToolbar extends StatelessWidget {
  /// Creates a widget that lays out its children in a manner suitable for a
  /// toolbar.
  const WoltNavigationToolbar({
    super.key,
    this.leading,
    this.middle,
    this.trailing,
    this.centerMiddle = true,
    this.middleSpacing = kMiddleSpacing,
  });

  /// The default spacing around the [middle] widget in dp.
  static const double kMiddleSpacing = 16.0;

  /// Widget to place at the start of the horizontal toolbar.
  final Widget? leading;

  /// Widget to place in the middle of the horizontal toolbar, occupying
  /// as much remaining space as possible.
  final Widget? middle;

  /// Widget to place at the end of the horizontal toolbar.
  final Widget? trailing;

  /// Whether to align the [middle] widget to the center of this widget or
  /// next to the [leading] widget when false.
  final bool centerMiddle;

  /// The spacing around the [middle] widget on horizontal axis.
  ///
  /// Defaults to [kMiddleSpacing].
  final double middleSpacing;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    final TextDirection textDirection = Directionality.of(context);
    return CustomMultiChildLayout(
      delegate: _ToolbarLayout(
        centerMiddle: centerMiddle,
        middleSpacing: middleSpacing,
        textDirection: textDirection,
      ),
      children: [
        if (leading != null)
          LayoutId(id: _ToolbarSlot.leading, child: leading!),
        if (middle != null) LayoutId(id: _ToolbarSlot.middle, child: middle!),
        if (trailing != null)
          LayoutId(id: _ToolbarSlot.trailing, child: trailing!),
      ],
    );
  }
}

enum _ToolbarSlot {
  leading,
  middle,
  trailing,
}

class _ToolbarLayout extends MultiChildLayoutDelegate {
  _ToolbarLayout({
    required this.centerMiddle,
    required this.middleSpacing,
    required this.textDirection,
  });

  // If false the middle widget should be start-justified within the space
  // between the leading and trailing widgets.
  // If true the middle widget is centered within the toolbar (not within the horizontal
  // space between the leading and trailing widgets).
  final bool centerMiddle;

  /// The spacing around middle widget on horizontal axis.
  final double middleSpacing;

  final TextDirection textDirection;

  @override
  void performLayout(Size size) {
    double leadingWidth = 0.0;
    double trailingWidth = 0.0;

    if (hasChild(_ToolbarSlot.leading)) {
      final BoxConstraints constraints = BoxConstraints(
        maxWidth: size.width,
        minHeight:
            size.height, // The height should be exactly the height of the bar.
        maxHeight: size.height,
      );
      leadingWidth = layoutChild(_ToolbarSlot.leading, constraints).width;
      final double leadingX;
      switch (textDirection) {
        case TextDirection.rtl:
          leadingX = size.width - leadingWidth;
          break;
        case TextDirection.ltr:
          leadingX = 0.0;
          break;
      }
      positionChild(_ToolbarSlot.leading, Offset(leadingX, 0.0));
    }

    if (hasChild(_ToolbarSlot.trailing)) {
      final BoxConstraints constraints = BoxConstraints.loose(size);
      final Size trailingSize = layoutChild(_ToolbarSlot.trailing, constraints);
      final double trailingX;
      switch (textDirection) {
        case TextDirection.rtl:
          trailingX = 0.0;
          break;
        case TextDirection.ltr:
          trailingX = size.width - trailingSize.width;
          break;
      }
      final double trailingY = (size.height - trailingSize.height) / 2.0;
      trailingWidth = trailingSize.width;
      positionChild(_ToolbarSlot.trailing, Offset(trailingX, trailingY));
    }

    if (hasChild(_ToolbarSlot.middle)) {
      if (trailingWidth == 0 && leadingWidth != 0) {
        trailingWidth = leadingWidth;
      }
      if (leadingWidth == 0 && trailingWidth != 0) {
        leadingWidth = trailingWidth;
      }
      final double maxWidth = max(
        size.width - leadingWidth - trailingWidth - middleSpacing * 2.0,
        0.0,
      );
      final BoxConstraints constraints =
          BoxConstraints.loose(size).copyWith(maxWidth: maxWidth);
      final Size middleSize = layoutChild(_ToolbarSlot.middle, constraints);

      final double middleStartMargin = leadingWidth + middleSpacing;
      double middleStart = middleStartMargin;
      final double middleY = (size.height - middleSize.height) / 2.0;
      // If the centered middle will not fit between the leading and trailing
      // widgets, then align its left or right edge with the adjacent boundary.
      if (centerMiddle) {
        middleStart = (size.width - middleSize.width) / 2.0;
        if (middleStart + middleSize.width > size.width - trailingWidth) {
          middleStart =
              size.width - trailingWidth - middleSize.width - middleSpacing;
        } else if (middleStart < middleStartMargin) {
          middleStart = middleStartMargin;
        }
      }

      final double middleX;
      switch (textDirection) {
        case TextDirection.rtl:
          middleX = size.width - middleSize.width - middleStart;
          break;
        case TextDirection.ltr:
          middleX = middleStart;
          break;
      }

      positionChild(_ToolbarSlot.middle, Offset(middleX, middleY));
    }
  }

  @override
  bool shouldRelayout(_ToolbarLayout oldDelegate) {
    return oldDelegate.centerMiddle != centerMiddle ||
        oldDelegate.middleSpacing != middleSpacing ||
        oldDelegate.textDirection != textDirection;
  }
}
