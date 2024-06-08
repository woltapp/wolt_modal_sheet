import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// Implements a customizable bottom sheet modal that extends the base [WoltModalType].
class WoltBottomSheetType extends WoltModalType {
  /// Constructs a `WoltBottomSheet` with specific styles and behaviors predefined.
  /// The modal is set to be draggable to dismiss, but this can be disabled at page level.
  const WoltBottomSheetType()
      : super(
          shapeBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
          ),
          isDragEnabled: true,
          isAtMaxHeight: false,
        );

  /// Provides an accessibility label that describes the bottom sheet's function and type.
  /// This label is used by screen readers to enhance accessibility for users with visual
  /// impairments.
  ///
  /// [context]: The build context used for accessing localized strings.
  ///
  /// Returns a localized description of the bottom sheet, typically "bottom sheet".
  @override
  String routeLabel(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.bottomSheetLabel;
  }

  /// Specifies the size constraints for the modal based on the available space.
  /// It ensures that the modal uses the full width of the screen while limiting its maximum
  /// height to 90% of the screen height. Overriding this method allows for customizing the
  /// modal's size.
  ///
  /// [availableSize]: The total available space that can be used by the modal.
  ///
  /// Returns a [BoxConstraints] that dictate how large the bottom sheet can be.
  @override
  BoxConstraints layoutModal(Size availableSize) {
    return BoxConstraints(
      minWidth: availableSize.width,
      maxWidth: availableSize.width,
      minHeight: 0,
      maxHeight: availableSize.height * 0.9,
    );
  }

  /// Calculates the position of the modal within its parent container. [Offset.zero]
  ///
  /// [availableSize]: The size of the parent container or screen.
  /// [modalContentSize]: The actual size of the modal, which might be less than the maximum
  /// depending on content.
  ///
  /// Returns the starting offset for the modal.
  @override
  Offset positionModal(Size availableSize, Size modalContentSize) {
    return Offset(0, availableSize.height - modalContentSize.height);
  }

  /// Enhances the visual presentation of the modal's content by optionally incorporating safe area insets
  /// and a tinted background color. This is particularly useful for modals that need to respect the device's
  /// screen edges, like the notch or bottom navigation areas.
  ///
  /// [context]: The build context.
  /// [child]: The content widget of the modal.
  /// [useSafeArea]: A flag to determine whether to apply safe area constraints.
  /// [tintedBackgroundColor]: A background color applied to areas not covered by the modal.
  ///
  /// Returns a widget that is either wrapped with safe area constraints or not, based on the provided flag.
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

  /// Animates the bottom sheet's appearance with a vertical slide transition.
  /// This method defines how the modal enters the screen, emphasizing a smooth and natural motion from bottom to top.
  ///
  /// [context]: The build context.
  /// [animation]: The primary animation controller for the modal's appearance.
  /// [secondaryAnimation]: The animation for the route being pushed on top of this route. This
  /// animation lets this route coordinate with the entrance and exit transition
  /// of route pushed on top of this route.
  /// [child]: The content widget to be animated.
  ///
  /// Returns a `SlideTransition` widget that manages the animation of the modal's entrance.
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
}
