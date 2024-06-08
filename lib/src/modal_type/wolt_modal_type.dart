import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

export 'wolt_bottom_sheet_type.dart';
export 'wolt_dialog_type.dart';
export 'wolt_modal_type_safe_area_filling.dart';

/// Represents the base class for different modal types used within the UI.
/// This abstract class provides a template for defining modal behavior and styles,
/// ensuring consistent layout, transitions, and accessibility features across
/// various modal implementations such as bottom sheets, dialog boxes, or side sheets.
///
/// The class should be extended to create specific modal types by providing
/// concrete implementations of the abstract methods and properties.
abstract class WoltModalType {
  /// Constructs a `WoltModalType` instance with the specified border shape,
  /// draggable behavior, and maximum height setting.
  ///
  /// Parameters:
  ///   [shapeBorder]: Defines the shape border of the modal. Each modal type
  ///                  can specify its own border style for unique visual presentation.
  ///   [isDragEnabled]: Indicates whether the modal can be dragged. This is typically
  ///                    used in bottom sheets to allow users to adjust the modal's position.
  ///   [isAtMaxHeight]: Determines whether the modal should always use the maximum
  ///                    available height. Useful for creating full-screen modals or side sheet.
  const WoltModalType({
    required this.shapeBorder,
    this.isDragEnabled,
    this.isAtMaxHeight = false,
  });

  /// Factory method to create a standard bottom sheet modal.
  factory WoltModalType.bottomSheet() => const WoltBottomSheetType();

  /// Factory method to create a standard dialog modal.
  factory WoltModalType.dialog() => const WoltDialogType();

  /// Factory method to create a side sheet modal.
  factory WoltModalType.sideSheet({
    bool isBottomSafeAreaFilled = true,
    bool isTopSafeAreaFilled = true,
    bool isEndSafeAreaFilled = true,
  }) =>
      WoltSideSheetModal(
        isBottomSafeAreaFilled: isBottomSafeAreaFilled,
        isTopSafeAreaFilled: isTopSafeAreaFilled,
        isEndSafeAreaFilled: isEndSafeAreaFilled,
      );

  /// Shape of the modal's border. This can be rounded, rectangular, etc.,
  /// depending on the modal type.
  final ShapeBorder shapeBorder;

  /// Property that allows the modal to be dragged if set to `true`.
  final bool? isDragEnabled;

  /// Indicates if the modal is using the full possible height of the screen.
  final bool isAtMaxHeight;

  /// Defines the constraints for the modal based on the available screen size.
  /// This method must be implemented to specify how the modal should be sized
  /// within its parent container.
  ///
  /// [availableSize]: The size of the parent container or screen.
  ///
  /// Returns a `BoxConstraints` object that dictates the size of the modal.
  BoxConstraints layoutModal(Size availableSize);

  /// Determines the position of the modal within its parent container.
  /// This method must be implemented to specify the starting position of the modal. The top-left
  /// position is used to place the modal within the parent container.
  ///
  /// [availableSize]: The size of the parent container or screen.
  /// [modalContentSize]: The size of the modal content, often derived from `layoutModal`.
  ///
  /// Returns an `Offset` object representing the top-left position of the modal.
  Offset positionModal(Size availableSize, Size modalContentSize);

  /// Provides a semantic label for accessibility purposes based on the modal type.
  /// This method should return a string that describes the modal for screen readers.
  ///
  /// [context]: The build context can be used to access localizations.
  ///
  /// Returns a string representing the accessibility label for the modal.
  String routeLabel(BuildContext context);

  /// Animates the modal's appearance with a custom transition. This method allows
  /// each modal type to define its own animation for appearing on screen.
  ///
  /// [context]: The build context.
  /// [animation]: The primary animation controller for the modal's visibility.
  /// [secondaryAnimation]: The animation for the route being pushed on top of this route. This
  /// animation lets this route coordinate with the entrance and exit transition
  /// of route pushed on top of this route.
  /// [child]: The widget (or modal content) to be animated.
  ///
  /// Returns a widget that wraps the `child` with animation behavior.
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  );

  /// Decorates the modal's page content, typically by adding safe area considerations
  /// or a background color.
  ///
  /// [context]: The build context.
  /// [child]: The modal content widget to be decorated.
  /// [useSafeArea]: A boolean that specifies whether to include safe area insets.
  /// [tintedBackgroundColor]: The background color of the modal content.
  ///
  /// Returns a widget that includes the `child` with additional styling or layout adjustments.
  /// By default, this method wraps the `child` with safe area constraints if `useSafeArea` is
  /// `true`.
  Widget decoratePage(
    BuildContext context,
    Widget child,
    bool useSafeArea,
    Color tintedBackgroundColor,
  ) =>
      useSafeArea ? SafeArea(child: child) : child;

  /// Helper getters to determine if type of modal is [WoltBottomSheetType]. These can be used to
  /// apply type-specific logic or styling based on the modal's implementation.
  bool get isBottomSheet => this is WoltBottomSheetType;

  /// Helper getters to determine if type of modal is [WoltModalTypeDialog]. These can be used to
  /// apply type-specific logic or styling based on the modal's implementation.
  bool get isDialog => this is WoltDialogType;

  /// Helper getters to determine if type of modal is [WoltSideSheetModal]. These can be used to
  /// apply type-specific logic or styling based on the modal's implementation.
  bool get isSideSheet => this is WoltSideSheetModal;
}

/// Concrete implementation for a side sheet modal.
/// Side sheets are similar to side navigation drawers but may be used for additional contextual
/// information or actions related to the current view, sliding from the side of the screen.
class WoltSideSheetModal extends WoltModalType {
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

  @override
  String routeLabel(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.drawerLabel;
  }

  @override
  BoxConstraints layoutModal(Size availableSize) {
    return BoxConstraints(
      minWidth: 0,
      maxWidth: availableSize.width * 0.5,
      minHeight: availableSize.height,
      maxHeight: availableSize.height,
    );
  }

  @override
  Offset positionModal(Size availableSize, Size modalContentSize) {
    return Offset(availableSize.width - modalContentSize.width, 0);
  }

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

class WoltModalTypeTopSafeAreaFilling extends StatelessWidget {
  const WoltModalTypeTopSafeAreaFilling(
    this.safeAreaColor, {
    this.width = double.infinity,
    super.key,
  });

  final Color safeAreaColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: safeAreaColor,
      child: SizedBox(height: MediaQuery.paddingOf(context).top, width: width),
    );
  }
}

class WoltModalTypeBottomSafeAreaFilling extends StatelessWidget {
  const WoltModalTypeBottomSafeAreaFilling(
    this.safeAreaColor, {
    this.width = double.infinity,
    super.key,
  });

  final Color safeAreaColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: safeAreaColor,
      child:
          SizedBox(height: MediaQuery.paddingOf(context).bottom, width: width),
    );
  }
}

class WoltModalTypeStartSafeAreaFilling extends StatelessWidget {
  const WoltModalTypeStartSafeAreaFilling(
    this.safeAreaColor, {
    super.key,
  });

  final Color safeAreaColor;

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets padding = MediaQuery.paddingOf(context);
    switch (textDirection) {
      case TextDirection.ltr:
        return ColoredBox(
          color: safeAreaColor,
          child: SizedBox(
            height: double.infinity,
            width: padding.left,
          ),
        );
      case TextDirection.rtl:
        return ColoredBox(
          color: safeAreaColor,
          child: SizedBox(
            height: double.infinity,
            width: padding.right,
          ),
        );
    }
  }
}

class WoltModalTypeEndSafeAreaFilling extends StatelessWidget {
  const WoltModalTypeEndSafeAreaFilling(
    this.safeAreaColor, {
    super.key,
  });

  final Color safeAreaColor;

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets padding = MediaQuery.paddingOf(context);
    switch (textDirection) {
      case TextDirection.ltr:
        return ColoredBox(
          color: safeAreaColor,
          child: SizedBox(
            height: double.infinity,
            width: padding.right,
          ),
        );
      case TextDirection.rtl:
        return ColoredBox(
          color: safeAreaColor,
          child: SizedBox(
            height: double.infinity,
            width: padding.left,
          ),
        );
    }
  }
}
