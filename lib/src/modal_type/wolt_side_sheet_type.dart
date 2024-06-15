import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// A customizable side sheet modal that extends [WoltModalType].
class WoltSideSheetType extends WoltModalType {
  /// Constructs a [WoltSideSheetType].
  const WoltSideSheetType({
    ShapeBorder shapeBorder = _defaultShapeBorder,
    bool? isDragEnabled = false,
    bool forceMaxHeight = true,
    Duration transitionDuration = _defaultEnterDuration,
    Duration reverseTransitionDuration = _defaultExitDuration,
  }) : super(
          shapeBorder: shapeBorder,
          isDragToDismissEnabled: isDragEnabled,
          forceMaxHeight: forceMaxHeight,
          transitionDuration: transitionDuration,
          reverseTransitionDuration: reverseTransitionDuration,
        );

  static const Duration _defaultEnterDuration = Duration(milliseconds: 250);
  static const Duration _defaultExitDuration = Duration(milliseconds: 250);
  static const ShapeBorder _defaultShapeBorder = RoundedRectangleBorder(
    borderRadius: BorderRadiusDirectional.only(
      topStart: Radius.circular(16.0),
      bottomStart: Radius.circular(16.0),
    ),
  );

  /// Provides an accessibility label that describes the side sheet's function and type.
  ///
  /// This label is used by screen readers to enhance accessibility for users with visual
  /// impairments, helping them understand the purpose of the side sheet.
  ///
  /// [context] The build context used for accessing localized strings.
  ///
  /// Returns a localized description of the side sheet, typically "drawer".
  @override
  String routeLabel(BuildContext context) =>
      MaterialLocalizations.of(context).drawerLabel;

  /// Specifies the size constraints for the modal based on the available space.
  ///
  /// This method limits the width of the side sheet to 524 pixels or less, depending on available
  /// space, ensuring it does not overpower the main content area. The height is set to match the
  /// full height of the screen.
  ///
  /// [availableSize]: The total available space that can be used by the modal.
  ///
  /// Returns [BoxConstraints] that dictate the maximum and minimum size of the side sheet.
  @override
  BoxConstraints layoutModal(Size availableSize) {
    final width = min(524.0, max(0.0, availableSize.width - 32.0));
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      minHeight: availableSize.height,
      maxHeight: availableSize.height,
    );
  }

  /// Calculates the position of the modal within the screen to ensure it is aligned correctly
  /// with the screen's edge.
  ///
  /// This method positions the modal to slide in from the side, aligning its edge with the
  /// edge of the screen.
  ///
  /// [availableSize] The size of the parent container or screen.
  /// [modalContentSize] The actual size of the modal, which might be less than the maximum
  /// depending on content.
  ///
  /// Returns the starting offset for the modal, ensuring it is positioned correctly.
  @override
  Offset positionModal(Size availableSize, Size modalContentSize) {
    final xOffset = max(0.0, availableSize.width - modalContentSize.width);
    return Offset(xOffset, 0);
  }

  /// Enhances the visual presentation of the modal's content by optionally incorporating safe area insets
  /// and a tinted background color.
  ///
  /// This method adds visual layers to the side sheet, filling safe areas with colors to blend the
  /// modal seamlessly into the app's layout. It is particularly useful in layouts that require a
  /// cohesive look across different device safe areas.
  ///
  /// [context] The build context.
  /// [child] The content widget of the modal.
  /// [useSafeArea] A flag to determine whether to apply safe area constraints.
  ///
  /// Returns a widget that is either wrapped with safe area constraints or not, based on the provided flag.
  @override
  Widget decoratePageContent(
    BuildContext context,
    Widget child,
    bool useSafeArea,
  ) {
    final TextDirection textDirection = Directionality.of(context);
    return useSafeArea
        ? SafeArea(
            left: textDirection == TextDirection.ltr ? false : true,
            right: textDirection == TextDirection.ltr ? true : false,
            top: true,
            bottom: true,
            child: child,
          )
        : child;
  }

  @override
  Widget decorateModal(
    BuildContext context,
    Widget modal,
    bool useSafeArea,
  ) =>
      modal;

  /// Defines the transition animation for the side sheet's appearance, using a slide motion from the side.
  ///
  /// This method customizes how the modal enters the screen, emphasizing a smooth lateral movement
  /// that enhances the user's experience by providing a natural and unobtrusive entry for the modal.
  ///
  /// [context] The build context.
  /// [animation] The primary animation controller for the modal's appearance.
  /// [secondaryAnimation] The animation for the route being pushed on top of this route.
  /// [child]: The content widget to be animated.
  ///
  /// Returns a transition widget that manages the animation of the side sheet's entrance.
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: animation.drive(
        Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.ease)),
      ),
      child: child,
    );
  }

  /// Provides a way to create a new `WoltDialogType` instance with modified properties.
  ///
  /// Useful for tweaking the appearance or behavior of the dialog without creating a completely
  /// new class.
  WoltSideSheetType copyWith({
    ShapeBorder? shapeBorder,
    bool? isDragToDismissEnabled,
    bool? forceMaxHeight,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
  }) {
    return WoltSideSheetType(
      shapeBorder: shapeBorder ?? this.shapeBorder,
      isDragEnabled: isDragToDismissEnabled ?? this.isDragToDismissEnabled,
      forceMaxHeight: forceMaxHeight ?? this.forceMaxHeight,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? this.reverseTransitionDuration,
    );
  }
}
