import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// A customizable dialog modal that extends [WoltModalType].
///
/// This modal type is usedin the large and medium window classes, to block interaction with the
/// rest of the screen, until users select between a few options.
///
/// The dialog's size is constrained to maintain readability and focus, with positioning
/// centered to emphasize importance and engagement.
class WoltDialogType extends WoltModalType {
  /// Creates a [WoltDialogType] with specified styles and behaviors.
  ///
  /// The modal is designed to be non-draggable and requiring interaction to dismiss.
  const WoltDialogType({
    ShapeBorder shapeBorder = _defaultShapeBorder,
    bool? isDragEnabled = false,
    bool isAtMaxHeight = false,
    Duration transitionDuration = _defaultEnterDuration,
    Duration reverseTransitionDuration = _defaultExitDuration,
  }) : super(
          shapeBorder: shapeBorder,
          isDragEnabled: isDragEnabled,
          isAtMaxHeight: isAtMaxHeight,
          transitionDuration: transitionDuration,
          reverseTransitionDuration: reverseTransitionDuration,
        );

  static const Duration _defaultEnterDuration = Duration(milliseconds: 200);
  static const Duration _defaultExitDuration = Duration(milliseconds: 200);
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
    const padding = 32.0; // padding around the dialog for aesthetics
    double width;
    final availableWidth = availableSize.width;
    if (availableWidth > 767.0) {
      width = 404.0; // optimal width for larger screens
    } else if (availableWidth > 280.0 + padding) {
      width = 280.0; // standard width for moderate screens
    } else {
      width = availableWidth - padding; // adjust for very small screens
    }

    final availableHeight = availableSize.height;
    if (availableHeight >= 360) {
      return BoxConstraints(
        minWidth: width,
        maxWidth: width,
        minHeight: 360,
        maxHeight: max(360, availableHeight * 0.8),
      );
    } else {
      return BoxConstraints(
        minWidth: width,
        maxWidth: width,
        minHeight: availableHeight * 0.8,
        maxHeight: availableHeight * 0.8,
      );
    }
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
  Offset positionModal(Size availableSize, Size modalContentSize) {
    final xOffset =
        max(0.0, (availableSize.width - modalContentSize.width) / 2);
    final yOffset =
        max(0.0, (availableSize.height - modalContentSize.height) / 2);
    return Offset(xOffset, yOffset);
  }

  /// Defines a transition animation for the dialog's appearance.
  ///
  /// This method customizes how the dialog enters the screen, using animation to smoothly
  /// transition.
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
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.linear,
      ),
      child: child,
    );
  }

  /// Provides a way to create a new `WoltDialogType` instance with modified properties.
  ///
  /// Useful for tweaking the appearance or behavior of the dialog without creating a completely
  /// new class.
  WoltDialogType copyWith({
    ShapeBorder? shapeBorder,
    bool? isDragEnabled,
    bool? isAtMaxHeight,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
  }) {
    return WoltDialogType(
      shapeBorder: shapeBorder ?? this.shapeBorder,
      isDragEnabled: isDragEnabled ?? this.isDragEnabled,
      isAtMaxHeight: isAtMaxHeight ?? this.isAtMaxHeight,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? this.reverseTransitionDuration,
    );
  }

  /// A dialog does not utilize the safe area regardless of the [useSafeArea] value, so this method
  /// returns the child as is.
  @override
  Widget decoratePage(
    BuildContext context,
    Widget child,
    bool useSafeArea,
    Color tintedBackgroundColor,
  ) =>
      child;
}
