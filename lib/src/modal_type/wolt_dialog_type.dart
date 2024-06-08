import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// Implements a customizable dialog modal that extends the base [WoltModalType].
/// This modal type is commonly used for interrupting user flow to present critical information,
/// seek confirmations, or gather input from the user. Dialogs are typically centered on the screen
/// and demand interaction before proceeding.
///
/// The dialog's size can be constrained, and its positioning is generally centered to maintain focus
/// and prominence on the screen, making it ideal for important interactions that require user attention.
class WoltDialogType extends WoltModalType {
  /// Constructs a `WoltModalTypeDialog` with specific styles and behaviors predefined.
  /// This modal is not draggable and is designed to be modal in nature, often requiring user interaction
  /// to dismiss.
  const WoltDialogType()
      : super(
          shapeBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          isDragEnabled: false,
          isAtMaxHeight: false,
        );

  /// Provides an accessibility label that describes the dialog's function and type.
  /// This label is used by screen readers to enhance accessibility for users with visual
  /// impairments, helping them understand the purpose of the dialog.
  ///
  /// [context]: The build context used for accessing localized strings.
  ///
  /// Returns a localized description of the dialog, typically "dialog".
  @override
  String routeLabel(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.dialogLabel;
  }

  /// Specifies the size constraints for the modal based on the available space.
  /// This method limits the dialog's width to a maximum of 480 pixels to ensure
  /// readability and focus, or it uses the full width if less than 480 pixels are available.
  /// The height is dynamically calculated based on content but does not exceed 90% of the screen height.
  ///
  /// [availableSize]: The total available space that can be used by the modal.
  ///
  /// Returns a [BoxConstraints] that dictate the maximum and minimum size of the dialog.
  @override
  BoxConstraints layoutModal(Size availableSize) {
    return BoxConstraints(
      minWidth: min(availableSize.width, 480),
      maxWidth: min(availableSize.width, 480),
      minHeight: 0,
      maxHeight: availableSize.height * 0.9,
    );
  }

  /// Calculates the position of the modal within its parent container to ensure it is centered.
  /// This method uses the size of the dialog and the available space to calculate a central position,
  /// making the dialog prominent and focused in the user's view.
  ///
  /// [availableSize]: The size of the parent container or screen.
  /// [modalContentSize]: The actual size of the modal, which might be less than the maximum
  /// depending on content.
  ///
  /// Returns the starting offset for the modal, ensuring it is centered within the available space.
  @override
  Offset positionModal(Size availableSize, Size modalContentSize) {
    return Offset(
      (availableSize.width - modalContentSize.width) / 2,
      (availableSize.height - modalContentSize.height) / 2,
    );
  }

  /// Animates the dialog's appearance with a scaling transition.
  /// This method defines how the dialog scales up slightly from a slightly smaller size,
  /// creating a gentle and less abrupt appearance. This animation aids in drawing attention
  /// to the dialog while being less jarring to the user.
  ///
  /// [context]: The build context.
  /// [animation]: The primary animation controller for the dialog's appearance.
  /// [secondaryAnimation]: The animation for the route being pushed on top of this route. This
  /// animation lets this route coordinate with the entrance and exit transition
  /// of route pushed on top of this route.
  /// [child]: The content widget to be animated.
  ///
  /// Returns a `ScaleTransition` widget that manages the animation of the dialog's entrance,
  /// scaling from 90% to full size.
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: animation.drive(Tween(
        begin: 0.9,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.ease))),
      child: child,
    );
  }
}
