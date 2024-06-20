import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_modal_dismiss_direction.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// A customizable side sheet modal that extends [WoltModalType].
class WoltSideSheetType extends WoltModalType {
  /// Constructs a [WoltSideSheetType].
  const WoltSideSheetType({
    ShapeBorder shapeBorder = _defaultShapeBorder,
    bool forceMaxHeight = true,
    Duration transitionDuration = _defaultEnterDuration,
    Duration reverseTransitionDuration = _defaultExitDuration,
    WoltModalDismissDirection? dismissDirection =
        WoltModalDismissDirection.endToStart,
    double minFlingVelocity = 365.0,
  }) : super(
          shapeBorder: shapeBorder,
          showDragHandle: false,
          forceMaxHeight: forceMaxHeight,
          transitionDuration: transitionDuration,
          reverseTransitionDuration: reverseTransitionDuration,
          dismissDirection: dismissDirection,
          minFlingVelocity: minFlingVelocity,
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

  /// Calculates the position of the modal within the screen based on text direction.
  /// This ensures correct alignment with the screen's edge appropriate for the text direction.
  @override
  Offset positionModal(
    Size availableSize,
    Size modalContentSize,
    TextDirection textDirection,
  ) {
    final xOffset = textDirection == TextDirection.rtl
        ? 0.0
        : max(0.0, availableSize.width - modalContentSize.width);
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

  /// Animates the modal's appearance with a slide transition adjusted for text direction.
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;
    Offset beginOffset =
        isRtl ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);

    return SlideTransition(
      position: animation.drive(
        Tween(
          begin: beginOffset,
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
    bool? forceMaxHeight,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    WoltModalDismissDirection? dismissDirection,
    double? minFlingVelocity,
  }) {
    return WoltSideSheetType(
      shapeBorder: shapeBorder ?? this.shapeBorder,
      forceMaxHeight: forceMaxHeight ?? this.forceMaxHeight,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? this.reverseTransitionDuration,
      dismissDirection: dismissDirection ?? this.dismissDirection,
      minFlingVelocity: minFlingVelocity ?? this.minFlingVelocity,
    );
  }
}
