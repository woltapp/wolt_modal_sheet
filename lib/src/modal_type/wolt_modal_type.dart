import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

export 'wolt_bottom_sheet_type.dart';
export 'wolt_dialog_type.dart';
export 'wolt_side_sheet_type.dart';
export 'wolt_modal_type_safe_area_filling.dart';

/// An abstract base class for creating different types of modals within a UI.
///
/// This class serves as a template for defining the behavior and styles of modals,
/// ensuring consistency in layout, transitions, and accessibility across various
/// implementations such as bottom sheets, dialogs, side sheets, or custom modal types.
///
/// To create specific modal types, extend this class and provide concrete implementations
/// of the required methods and properties.
abstract class WoltModalType {
  /// Creates a [WoltModalType] instance.
  ///
  /// Typically, subclasses will set the modal properties such as border shape,
  /// drag behavior, height constraints and transition durations.
  const WoltModalType({
    this.shapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    this.isDragEnabled = false,
    this.isAtMaxHeight = false,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
  });

  /// Creates the default bottom sheet modal.
  factory WoltModalType.bottomSheet() => const WoltBottomSheetType();

  /// Creates the default dialog modal.
  factory WoltModalType.dialog() => const WoltDialogType();

  /// The duration of the modal's forward transition animation.
  ///
  /// Also see:
  ///
  /// * [reverseTransitionDuration], which specifies the duration of the transition
  /// when played in reverse. By default, both durations are set to 300 milliseconds.
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

  /// Determines whether the modal is draggable.
  ///
  /// If set to `true`, the modal can be dismissed by dragging, typically used in bottom sheets.
  final bool? isDragEnabled;

  /// Forces the modal content to use the maximum available height if set to `true`.
  ///
  /// This is useful for modals like side sheets that need to occupy the full screen height.
  final bool isAtMaxHeight;

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
  Offset positionModal(Size availableSize, Size modalContentSize);

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

  /// Applies additional decorations to the modal's content.
  ///
  /// This method can be overridden to provide custom decorations such as safe area padding
  /// adjustments. By default, it applies safe area constraints if [useSafeArea] is `true`.
  Widget decoratePage(
    BuildContext context,
    Widget child,
    bool useSafeArea,
    Color tintedBackgroundColor,
  ) =>
      useSafeArea ? SafeArea(child: child) : child;
}
