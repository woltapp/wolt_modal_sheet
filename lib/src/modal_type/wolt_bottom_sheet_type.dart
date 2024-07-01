import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_modal_dismiss_direction.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// A customizable bottom sheet modal that extends [WoltModalType].
///
/// This class implements a bottom sheet modal with predefined styles and behaviors.
/// It is designed to be draggable, allowing users to dismiss it by swiping down. This behavior
/// can be overridden at the page level and modal level.
class WoltBottomSheetType extends WoltModalType {
  /// Creates a [WoltBottomSheetType] with optional customizations.
  const WoltBottomSheetType({
    ShapeBorder shapeBorder = _defaultShapeBorder,
    bool? showDragHandle,
    bool forceMaxHeight = false,
    WoltModalDismissDirection? dismissDirection =
        WoltModalDismissDirection.down,
    Duration transitionDuration = _defaultEnterDuration,
    Duration reverseTransitionDuration = _defaultExitDuration,
    minFlingVelocity = 700.0,
  }) : super(
          shapeBorder: shapeBorder,
          forceMaxHeight: forceMaxHeight,
          transitionDuration: transitionDuration,
          reverseTransitionDuration: reverseTransitionDuration,
          dismissDirection: dismissDirection,
          minFlingVelocity: minFlingVelocity,
          showDragHandle: showDragHandle,
        );

  static const Duration _defaultEnterDuration = Duration(milliseconds: 350);
  static const Duration _defaultExitDuration = Duration(milliseconds: 250);
  static const ShapeBorder _defaultShapeBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
  );

  /// Provides an accessibility label for the bottom sheet, enhancing accessibility for users
  /// with visual impairments.
  ///
  /// This label helps screen readers describe the function and type of the bottom sheet.
  ///
  /// [context] is used to access localized strings.
  ///
  /// Returns a localized description of the bottom sheet, typically "bottom sheet".
  @override
  String routeLabel(BuildContext context) =>
      MaterialLocalizations.of(context).bottomSheetLabel;

  /// Specifies the size constraints for the modal based on the available space.
  ///
  /// This implementation ensures the modal uses the full width of the screen and limits its maximum
  /// height to 90% of the screen height, while maintaining a minimum height of 40% of the screen
  /// height.
  ///
  /// [availableSize] defines the total available space for the modal.
  ///
  /// Returns [BoxConstraints] that dictate the allowable size of the bottom sheet.
  @override
  BoxConstraints layoutModal(Size availableSize) {
    return BoxConstraints(
      minWidth: availableSize.width,
      maxWidth: availableSize.width,
      minHeight: availableSize.height * 0.4,
      maxHeight: availableSize.height * 0.9,
    );
  }

  /// Calculates the starting position for the modal within its parent container.
  ///
  /// The modal is positioned to start at the bottom of the available space.
  ///
  /// [availableSize] is the size of the parent container or screen.
  /// [modalContentSize] is the actual size of the modal, which might be less than the maximum
  /// depending on content.
  ///
  /// Returns an [Offset] representing the starting position of the modal.
  @override
  Offset positionModal(Size availableSize, Size modalContentSize, _) {
    return Offset(0, max(0.0, availableSize.height - modalContentSize.height));
  }

  /// Enhances the visual presentation of the modal by filling the safe area constraints with the
  /// tinted background color.
  ///
  /// This is useful for modals that must respect the device's screen edges, such as the notch or
  /// bottom navigation areas. If [useSafeArea] is `true`, the modal content is wrapped with safe
  /// area constraints filled with the tinted background color.
  ///
  /// [context] is the build context.
  /// [child] is the content widget of the modal.
  /// [useSafeArea] determines whether safe area constraints.
  ///
  /// Returns a widget that includes the modal content, optionally wrapped with safe area constraints.
  @override
  Widget decoratePageContent(
    BuildContext context,
    Widget child,
    bool useSafeArea,
  ) {
    return useSafeArea
        ? SafeArea(
            top: false,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: child,
            ),
          )
        : child;
  }

  @override
  Widget decorateModal(
    BuildContext context,
    Widget modal,
    bool useSafeArea,
  ) =>
      useSafeArea
          ? SafeArea(
              top: false,
              bottom: false,
              child: modal,
            )
          : modal;

  /// Defines the animation for the modal's appearance.
  ///
  /// [context] is the build context.
  /// [animation] is the primary animation controller for the modal's appearance.
  /// [secondaryAnimation] coordinates with the transitions of other routes.
  /// [child] is the content widget to be animated.
  ///
  /// Returns a `SlideTransition` widget that manages the modal's entrance animation.
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final isClosing = animation.status == AnimationStatus.reverse;

    const enteringCubic = Cubic(0.1, 0.8, 0.2, 1.0);
    const exitingCubic = Cubic(0.5, 0, 0.7, 0.2);

    final cubic = isClosing ? exitingCubic : enteringCubic;
    final reverseCubic = isClosing ? enteringCubic : exitingCubic;

    final positionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: cubic,
        reverseCurve: reverseCubic,
      ),
    );

    return SlideTransition(
      position: positionAnimation,
      child: child,
    );
  }

  /// Provides a way to create a new `WoltBottomSheetType` instance with modified properties.
  ///
  /// Useful for tweaking the appearance or behavior of the bottom sheet without creating a
  /// completely new class.
  WoltBottomSheetType copyWith({
    ShapeBorder? shapeBorder,
    bool? showDragHandle,
    bool? forceMaxHeight,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    WoltModalDismissDirection? dismissDirection,
    double? minFlingVelocity,
  }) {
    return WoltBottomSheetType(
      shapeBorder: shapeBorder ?? this.shapeBorder,
      showDragHandle: showDragHandle ?? this.showDragHandle,
      forceMaxHeight: forceMaxHeight ?? this.forceMaxHeight,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? this.reverseTransitionDuration,
      dismissDirection: dismissDirection ?? this.dismissDirection,
      minFlingVelocity: minFlingVelocity ?? this.minFlingVelocity,
    );
  }
}
