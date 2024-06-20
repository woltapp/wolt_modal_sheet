import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_alert_dialog_type.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_modal_dismiss_direction.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

export 'wolt_bottom_sheet_type.dart';
export 'wolt_dialog_type.dart';
export 'wolt_side_sheet_type.dart';

/// An abstract base class for creating different types of modals within a UI.
///
/// To create specific modal types, extend this class and provide concrete implementations
/// of the required methods and properties.
abstract class WoltModalType {
  /// Creates a [WoltModalType] instance.
  const WoltModalType({
    this.shapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    this.showDragHandle,
    this.dismissDirection,
    this.forceMaxHeight = false,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.minFlingVelocity = 700.0,
  });

  /// Creates the default bottom sheet modal.
  factory WoltModalType.bottomSheet() => const WoltBottomSheetType();

  /// Creates the default dialog modal.
  factory WoltModalType.dialog() => const WoltDialogType();

  /// Creates the default side sheet modal.
  factory WoltModalType.sideSheet() => const WoltSideSheetType();

  /// Creates the default alert dialog modal.
  factory WoltModalType.alertDialog() => const WoltAlertDialogType();

  /// The duration of the modal's forward transition animation.
  ///
  /// Also see:
  ///
  /// * [reverseTransitionDuration], which specifies the duration of the transition
  /// when played in reverse. By default, both durations are same.
  final Duration transitionDuration;

  /// The duration of the modal's reverse transition animation.
  ///
  /// By default, set to the same value as [transitionDuration].
  final Duration reverseTransitionDuration;

  /// The border shape of the modal.
  ///
  /// This property can define a rounded, rectangular, or custom border shape based on
  /// the modal type.
  final ShapeBorder shapeBorder;

  /// Depending on the value of [dismissDirection], determines whether the modal is draggable.
  bool? get isDragToDismissEnabled {
    if (dismissDirection == null) return null;
    return dismissDirection != WoltModalDismissDirection.none;
  }

  /// Determines whether the modal should show a drag handle on the top centered position.
  final bool? showDragHandle;

  /// The direction in which the modal can be dismissed when drag to dismiss is enabled.
  final WoltModalDismissDirection? dismissDirection;

  /// The minimum velocity required for a drag gesture to be considered a fling.
  final double minFlingVelocity;

  /// Forces the modal content to use the maximum available height if set to `true`.
  ///
  /// This is useful for modals like side sheets that need to occupy the full screen height.
  final bool forceMaxHeight;

  /// Defines the constraints for the modal based on the available screen size.
  ///
  /// Implement this method to specify the modal's sizing within the route screen.
  ///
  /// Returns a [BoxConstraints] object that defines the modal's dimensions.
  BoxConstraints layoutModal(Size availableSize);

  /// Determines the modal's position within the route screen.
  ///
  /// Implement this method to specify the position of the modal. The position is specified as an
  /// [Offset] from the top-left corner of the container.
  ///
  /// Returns an [Offset] representing the modal's starting position.
  Offset positionModal(
    Size availableSize,
    Size modalContentSize,
    TextDirection textDirection,
  );

  /// Provides an accessibility label for the modal.
  ///
  /// Implement this method to return a string that describes the modal type for screen readers.
  /// [MaterialLocalizations] provides the default labels for common modal types. For example:
  /// MaterialLocalizations.of(context).bottomSheetLabel
  String routeLabel(BuildContext context);

  /// Animates the modal's appearance.
  ///
  /// Override this method to define custom animation effects for the modal's entry and exit.
  /// The [animation] controls the modal's visibility, and the [secondaryAnimation] coordinates
  /// with other routes' transitions.
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  );

  /// Applies additional decorations to the modal pqge content.
  ///
  /// This method can be overridden to provide custom decorations such as safe area padding
  /// adjustments inside the modal page content. By default, it does not apply any decoration.
  /// See the [WoltBottomSheetType] for an example of how overriding this method could be used to
  /// fill the bottom safe area.
  Widget decoratePageContent(
    BuildContext context,
    Widget child,
    bool useSafeArea,
  ) =>
      child;

  /// Applies additional decorations to the modal content.
  ///
  /// This method can be overridden to provide custom decorations such as safe area padding
  /// adjustments around the modal including the barrier. By default, it applies safe area
  /// constraints if [useSafeArea] is `true`.
  Widget decorateModal(
    BuildContext context,
    Widget modal,
    bool useSafeArea,
  ) =>
      useSafeArea ? SafeArea(child: modal) : modal;
}
