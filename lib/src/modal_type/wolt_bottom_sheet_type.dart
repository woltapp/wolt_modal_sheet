import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// A customizable bottom sheet modal that extends [WoltModalType].
///
/// This class implements a bottom sheet modal with predefined styles and behaviors.
/// It is designed to be draggable, allowing users to dismiss it by swiping down. This behavior
/// can be overridden at the page level.
///
/// Bottom sheet is used in the small window class instead of a side sheet, when users need to
/// provide input or to display a list of controls, like filters.
class WoltBottomSheetType extends WoltModalType {
  /// Creates a [WoltBottomSheetType] with optional customizations.
  ///
  /// By default, the modal is draggable and uses a rounded top border. These defaults can be
  /// overridden with custom values.
  const WoltBottomSheetType({
    ShapeBorder shapeBorder = _defaultShapeBorder,
    bool? isDragEnabled = true,
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

  static const Duration _defaultEnterDuration = Duration(milliseconds: 250);
  static const Duration _defaultExitDuration = Duration(milliseconds: 200);
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
  Offset positionModal(Size availableSize, Size modalContentSize) {
    return Offset(0, max(0.0, availableSize.height - modalContentSize.height));
  }

  /// Enhances the visual presentation of the modal by optionally filling the safe area
  /// constraints with the tinted background color.
  ///
  /// This is useful for modals that must respect the device's screen edges, such as the notch or
  /// bottom navigation areas. If [useSafeArea] is `true`, the modal content is wrapped with safe
  /// area constraints filled with the tinted background color.
  ///
  /// [context] is the build context.
  /// [child] is the content widget of the modal.
  /// [useSafeArea] determines whether safe area constraints.
  /// [tintedBackgroundColor] is the background color applied to areas not covered by the modal.
  ///
  /// Returns a widget that includes the modal content, optionally wrapped with safe area constraints.
  @override
  Widget decoratePage(
    BuildContext context,
    Widget child,
    bool useSafeArea,
    Color tintedBackgroundColor,
  ) {
    return useSafeArea
        ? Stack(
            children: [
              SafeArea(child: child),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child:
                    WoltModalTypeBottomSafeAreaFilling(tintedBackgroundColor),
              ),
            ],
          )
        : child;
  }

  /// Defines the animation for the modal's appearance with a vertical slide transition.
  ///
  /// This method customizes how the modal enters the screen, emphasizing a smooth and natural motion from the bottom to the top.
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
    return SlideTransition(
      position: animation.drive(
        Tween(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.ease)),
      ),
      child: child,
    );
  }

  /// Provides a way to create a new `WoltBottomSheetType` instance with modified properties.
  ///
  /// Useful for tweaking the appearance or behavior of the bottom sheet without creating a
  /// completely new class.
  WoltBottomSheetType copyWith({
    ShapeBorder? shapeBorder,
    bool? isDragEnabled,
    bool? isAtMaxHeight,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
  }) {
    return WoltBottomSheetType(
      shapeBorder: shapeBorder ?? this.shapeBorder,
      isDragEnabled: isDragEnabled ?? this.isDragEnabled,
      isAtMaxHeight: isAtMaxHeight ?? this.isAtMaxHeight,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? this.reverseTransitionDuration,
    );
  }
}
