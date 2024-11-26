import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/utils/wolt_breakpoints.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// A customizable dialog modal that extends [WoltModalType].
class WoltDialogType extends WoltModalType {
  /// Minimum distance around the modal content and the screen edges.
  static const minPadding = 48.0;

  /// Creates a [WoltDialogType] with specified styles and behaviors.
  const WoltDialogType({
    ShapeBorder shapeBorder = _defaultShapeBorder,
    bool forceMaxHeight = false,
    Duration transitionDuration = _defaultEnterDuration,
    Duration reverseTransitionDuration = _defaultExitDuration,
    bool? barrierDismissible,
  }) : super(
          shapeBorder: shapeBorder,
          forceMaxHeight: forceMaxHeight,
          transitionDuration: transitionDuration,
          reverseTransitionDuration: reverseTransitionDuration,
          showDragHandle: false,
          barrierDismissible: barrierDismissible,
        );

  static const Duration _defaultEnterDuration = Duration(milliseconds: 300);
  static const Duration _defaultExitDuration = Duration(milliseconds: 250);
  static const ShapeBorder _defaultShapeBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );

  /// Provides an accessibility label for the dialog, used by screen readers to improve accessibility.
  ///
  /// This label helps users with visual impairments understand the purpose and function of the dialog.
  ///
  /// [context] provides access to localized strings.
  ///
  /// Returns a localized description of the dialog, typically "dialog".
  @override
  String routeLabel(BuildContext context) =>
      MaterialLocalizations.of(context).dialogLabel;

  /// Specifies the size constraints for the dialog based on the available space.
  ///
  /// [availableSize] is the total available space for the modal.
  ///
  /// Returns [BoxConstraints] that define the maximum and minimum dimensions of the dialog.
  @override
  BoxConstraints layoutModal(Size availableSize) {
    const double minModalHeight = 360.0;
    final double minModalWidth = WoltBreakpoints.small.minValue;
    const double verticalBreakpoint = minModalHeight + minPadding;
    final double horizontalBreakpoint = minModalWidth + minPadding;

    final double availableWidth = availableSize.width;
    final double availableHeight = availableSize.height;

    double width;

    if (availableWidth > horizontalBreakpoint) {
      width = minModalWidth;
    } else {
      width = max(0, availableWidth - minPadding);
    }

    if (availableHeight >= verticalBreakpoint) {
      return BoxConstraints(
        minWidth: width,
        maxWidth: width,
        minHeight: 0,
        maxHeight: max(360, availableHeight * 0.8),
      );
    }
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      minHeight: 0,
      maxHeight: availableHeight * 0.8,
    );
  }

  /// Calculates the central position of the dialog within its parent container.
  ///
  /// This method ensures the dialog is centered both horizontally and vertically,
  /// reinforcing its prominence and focus within the user's view.
  ///
  /// [availableSize] is the size of the screen.
  /// [modalContentSize] is the actual size of the dialog, which might be less than the maximum
  /// depending on content.
  ///
  /// Returns an [Offset] that centers the dialog within the available space.
  @override
  Offset positionModal(Size availableSize, Size modalContentSize, _) {
    final xOffset =
        max(0.0, (availableSize.width - modalContentSize.width) / 2);
    final yOffset =
        max(0.0, (availableSize.height - modalContentSize.height) / 2);
    return Offset(xOffset, yOffset);
  }

  /// Defines a transition animation for the dialog's appearance.
  ///
  /// [context] is the build context.
  /// [animation] is the primary animation controller for the dialog's appearance.
  /// [secondaryAnimation] manages the coordination with other routes' transitions.
  /// [child] is the content widget to be animated.
  ///
  /// Returns a transition widget that manages the dialog's transition animation.
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final isClosing = animation.status == AnimationStatus.reverse;

    const enteringInterval = Interval(0.0, 100.0 / 300.0, curve: Curves.linear);
    const exitingInterval = Interval(100.0 / 250.0, 1.0, curve: Curves.linear);

    const enteringCubic = Cubic(0.2, 0.6, 0.4, 1.0);
    const exitingCubic = Cubic(0.5, 0, 0.7, 0.2);

    final interval = isClosing ? exitingInterval : enteringInterval;
    final reverseInterval = isClosing ? enteringInterval : exitingInterval;

    final cubic = isClosing ? exitingCubic : enteringCubic;
    final reverseCubic = isClosing ? enteringCubic : exitingCubic;

    final alphaAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animation,
      curve: interval,
      reverseCurve: reverseInterval,
    ));

    // Position animation for entering (96px upwards) and exiting (96px downwards)
    final positionAnimation = Tween<Offset>(
      end: const Offset(0.0, 0.0),
      begin: Offset(0.0, isClosing ? 0.05 : 0.1),
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: cubic,
        reverseCurve: reverseCubic,
      ),
    );

    return FadeTransition(
      opacity: alphaAnimation,
      child: SlideTransition(position: positionAnimation, child: child),
    );
  }

  /// Provides a way to create a new `WoltDialogType` instance with modified properties.
  ///
  /// Useful for tweaking the appearance or behavior of the dialog without creating a completely
  /// new class.
  WoltDialogType copyWith({
    ShapeBorder? shapeBorder,
    bool? forceMaxHeight,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    bool? barrierDismissible,
  }) {
    return WoltDialogType(
      shapeBorder: shapeBorder ?? this.shapeBorder,
      forceMaxHeight: forceMaxHeight ?? this.forceMaxHeight,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? this.reverseTransitionDuration,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
    );
  }

  /// We don't need to fill the safe area for the dialog because it's centered in the screen
  /// regardless.
  @override
  Widget decorateModal(BuildContext context, Widget modal, bool useSafeArea) =>
      modal;

  /// We don't need to fill the safe area for the dialog because it's centered in the screen
  /// regardless.
  @override
  Widget decoratePageContent(
    BuildContext context,
    Widget child,
    bool useSafeArea,
  ) =>
      child;
}
