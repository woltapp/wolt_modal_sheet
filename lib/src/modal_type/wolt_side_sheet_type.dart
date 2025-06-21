import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/utils/wolt_breakpoints.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// A customizable side sheet modal that extends [WoltModalType].
class WoltSideSheetType extends WoltModalType {
  /// Constructs a [WoltSideSheetType].
  const WoltSideSheetType({
    super.shapeBorder = _defaultShapeBorder,
    super.forceMaxHeight = true,
    super.transitionDuration = _defaultEnterDuration,
    super.reverseTransitionDuration = _defaultExitDuration,
    WoltModalDismissDirection super.dismissDirection =
        WoltModalDismissDirection.endToStart,
    super.minFlingVelocity = 365.0,
    super.closeProgressThreshold = 0.5,
    super.barrierDismissible,
  }) : super(
          showDragHandle: false,
        );

  static const Duration _defaultEnterDuration = Duration(milliseconds: 300);
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
    final width = min(
      WoltBreakpoints.small.minValue,
      max(0.0, availableSize.width - 32.0),
    );
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
            left: textDirection != TextDirection.ltr,
            right: textDirection == TextDirection.ltr,
            top: true,
            bottom: true,
            child: child,
          )
        : child;
  }

  @override
  Widget decorateModal(BuildContext context, Widget modal, bool useSafeArea) =>
      modal;

  /// Animates the modal's appearance with a slide transition adjusted for text direction.
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final isClosing = animation.status == AnimationStatus.reverse;

    const enteringInterval = Interval(0.0, 100.0 / 300.0, curve: Curves.linear);
    const exitingInterval = Interval(100.0 / 250.0, 1.0, curve: Curves.linear);

    const enteringCubic = Cubic(0.2, 0.6, 0.4, 1.0);
    const exitingCubic = Cubic(0.5, 0, 0.7, 0.2);

    final interval = isClosing ? exitingInterval : enteringInterval;
    final reverseInterval = isClosing ? enteringInterval : exitingInterval;

    final cubic = isClosing ? exitingCubic : enteringCubic;
    final reverseCubic = isClosing ? enteringCubic : exitingCubic;

    // Define the alpha animation for entering
    final alphaAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: interval,
        reverseCurve: reverseInterval,
      ),
    );

    // Define the position animation for entering
    final positionAnimation = Tween<Offset>(
      begin: isRtl ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0),
      end: Offset.zero,
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
  WoltSideSheetType copyWith({
    ShapeBorder? shapeBorder,
    bool? forceMaxHeight,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    WoltModalDismissDirection? dismissDirection,
    double? minFlingVelocity,
    double? closeProgressThreshold,
    bool? barrierDismissible,
  }) {
    return WoltSideSheetType(
      shapeBorder: shapeBorder ?? this.shapeBorder,
      forceMaxHeight: forceMaxHeight ?? this.forceMaxHeight,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? this.reverseTransitionDuration,
      dismissDirection: dismissDirection ?? this.dismissDirection!,
      minFlingVelocity: minFlingVelocity ?? this.minFlingVelocity,
      closeProgressThreshold:
          closeProgressThreshold ?? this.closeProgressThreshold,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
    );
  }
}
