import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// Implements a customizable side sheet modal that extends the base [WoltModalType].
/// Side sheets are used for presenting additional information or options related to the main
/// content without taking full focus away from it. They typically slide in from the side and
/// can be filled with navigation links, filters, or other controls.
///
/// This modal type is versatile and can be used in a variety of contexts where a full modal
/// or dialog would be too disruptive.
class WoltSideSheetModal extends WoltModalType {
  /// Constructs a `WoltSideSheetModal` with specific configuration for safe area filling.
  /// This modal uses the full height of the screen and is not draggable, ensuring it remains
  /// static unless dismissed.
  ///
  /// Parameters:
  ///   [isBottomSafeAreaFilled]: Ensures the bottom safe area is considered in the layout if `true`.
  ///   [isTopSafeAreaFilled]: Ensures the top safe area is considered in the layout if `true`.
  ///   [isEndSafeAreaFilled]: Ensures the end safe area is considered based on text direction if `true`.
  const WoltSideSheetModal({
    this.isBottomSafeAreaFilled = true,
    this.isTopSafeAreaFilled = true,
    this.isEndSafeAreaFilled = true,
  }) : super(
          shapeBorder: const RoundedRectangleBorder(),
          isDragEnabled: false,
          isAtMaxHeight: true,
        );

  final bool isBottomSafeAreaFilled;
  final bool isTopSafeAreaFilled;
  final bool isEndSafeAreaFilled;

  /// Accessibility label for the side sheet, providing context for screen readers.
  /// This method returns a label that helps users understand the function of the side sheet,
  /// which improves accessibility and usability.
  ///
  /// [context]: The build context used for accessing localized strings.
  ///
  /// Returns a string typically representing "drawer" to denote the side sheet's nature.
  @override
  String routeLabel(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.drawerLabel;
  }

  /// Defines the constraints for the side sheet based on the available screen size.
  /// This configuration limits the width to half of the screen width to balance visibility
  /// with the remaining application content, using the full height of the screen.
  ///
  /// [availableSize]: The total available space that can be used by the modal.
  ///
  /// Returns a [BoxConstraints] object specifying the width and height constraints for the side sheet.
  @override
  BoxConstraints layoutModal(Size availableSize) {
    return BoxConstraints(
      minWidth: 0,
      maxWidth: availableSize.width * 0.5,
      minHeight: availableSize.height,
      maxHeight: availableSize.height,
    );
  }

  /// Calculates the position of the side sheet within its parent container.
  /// This method ensures the side sheet slides in from the right (or left in RTL layouts),
  /// aligning its width with the calculated constraints and placing it adjacent to the main content.
  ///
  /// [availableSize]: The size of the parent container or screen.
  /// [modalContentSize]: The actual size of the modal, derived from `layoutModal`.
  ///
  /// Returns an `Offset` object representing the position where the side sheet should appear.
  @override
  Offset positionModal(Size availableSize, Size modalContentSize) {
    return Offset(availableSize.width - modalContentSize.width, 0);
  }

  /// Decorates the side sheet's content by potentially incorporating safe area adjustments
  /// and a tinted background for areas not covered by the modal. This method ensures the content
  /// respects the device's safe areas, improving usability on devices with notches or rounded corners.
  ///
  /// [context]: The build context.
  /// [child]: The content widget of the side sheet.
  /// [useSafeArea]: A flag indicating whether safe area insets should be applied.
  /// [tintedBackgroundColor]: A background color applied to non-covered areas, enhancing visual clarity.
  ///
  /// Returns a widget layout that respects the specified design and safety considerations.
  @override
  Widget decoratePage(
    BuildContext context,
    Widget child,
    bool useSafeArea,
    Color tintedBackgroundColor,
  ) {
    return useSafeArea
        ? LayoutBuilder(
            builder: (context, constraints) {
              final availableSize = constraints.biggest;
              final double modalWidth = layoutModal(availableSize).maxWidth;
              return Stack(
                children: [
                  SafeArea(child: child),
                  if (isBottomSafeAreaFilled)
                    PositionedDirectional(
                      bottom: 0,
                      start: modalWidth,
                      end: 0,
                      child: WoltModalTypeBottomSafeAreaFilling(
                        tintedBackgroundColor,
                        width: modalWidth,
                      ),
                    ),
                  if (isTopSafeAreaFilled)
                    PositionedDirectional(
                      top: 0,
                      start: modalWidth,
                      end: 0,
                      child: WoltModalTypeTopSafeAreaFilling(
                        tintedBackgroundColor,
                        width: modalWidth,
                      ),
                    ),
                  if (isEndSafeAreaFilled)
                    PositionedDirectional(
                      top: 0,
                      bottom: 0,
                      end: 0,
                      child: WoltModalTypeEndSafeAreaFilling(
                          tintedBackgroundColor),
                    ),
                ],
              );
            },
          )
        : child;
  }

  /// Manages the animation of the side sheet's entrance, using a horizontal slide transition.
  /// This transition smoothly animates the side sheet from off-screen to its calculated position,
  /// creating a natural flow that integrates well with the user's interaction.
  ///
  /// [context]: The build context.
  /// [animation]: The primary animation controller for the modal's visibility.
  /// [secondaryAnimation]: The animation for the route being pushed on top of this route. This
  /// animation lets this route coordinate with the entrance and exit transition
  /// of route pushed on top of this route.
  /// [child]: The content widget to be animated.
  ///
  /// Returns a `SlideTransition` that handles the side sheet's movement onto the screen.
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
}
