import 'dart:math';

import 'package:flutter/material.dart';

/// An abstract class representing the modal type for user interface displays.
/// This class provides an interface for modal implementations, defining fields used in the
/// calculation of modal dimensions, positions, and accessibility labels based on the modal's
/// type and context.
abstract class WoltModalType {
  const WoltModalType({
    required this.shapeBorder,
    this.isDragEnabled = false,
    this.isBottomSafeAreaFilled = false,
    this.isTopSafeAreaFilled = false,
    this.isStartSafeAreaFilled = false,
    this.isEndSafeAreaFilled = false,
    this.shouldForceContentToMaxHeight = false,
  });

  factory WoltModalType.bottomSheet() => const WoltModalTypeBottomSheet();

  factory WoltModalType.dialog() => const WoltModalTypeDialog();

  factory WoltModalType.sideSheet() => const WoltSideSheetModal();

  final ShapeBorder shapeBorder;
  final bool isDragEnabled;
  final bool isBottomSafeAreaFilled;
  final bool isTopSafeAreaFilled;
  final bool isStartSafeAreaFilled;
  final bool isEndSafeAreaFilled;
  final bool shouldForceContentToMaxHeight;

  BoxConstraints modalContentBoxConstraints(Size availableSize);

  Offset modalContentOffset(Size availableSize, Size modalContentSize);

  /// Provides a semantic label for accessibility purposes based on the modal type.
  ///
  /// Accessibility labels help screen readers describe the function of the modal to users with
  /// visual impairments.
  ///
  /// Parameters:
  /// - [context]: The build context used to access MaterialLocalizations.
  ///
  /// Returns:
  /// A string representing the semantic label for the modal.
  String routeLabel(BuildContext context);

  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  );

  bool get isBottomSheet => this is WoltModalTypeBottomSheet;

  bool get isDialog => this is WoltModalTypeDialog;

  bool get isSideSheet => this is WoltSideSheetModal;
}

/// Concrete implementation of a bottom sheet modal.
/// This modal type is typically used for actions or information that slides up from the bottom
/// of the screen, covering part or all of it.
class WoltModalTypeBottomSheet extends WoltModalType {
  const WoltModalTypeBottomSheet()
      : super(
          shapeBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
          ),
          isDragEnabled: true,
          isBottomSafeAreaFilled: true,
          shouldForceContentToMaxHeight: false,
        );

  @override
  String routeLabel(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.bottomSheetLabel;
    // supported.
  }

  @override
  BoxConstraints modalContentBoxConstraints(Size availableSize) {
    return BoxConstraints(
      minWidth: availableSize.width,
      maxWidth: availableSize.width,
      minHeight: 0,
      maxHeight: availableSize.height * 0.9,
    );
  }

  @override
  Offset modalContentOffset(Size availableSize, Size modalContentSize) {
    return Offset(0, availableSize.height - modalContentSize.height);
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
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.ease)),
      ),
      child: child,
    );
  }
}

/// Concrete implementation for a dialog modal.
/// Dialogs are centered modals that often require user interaction and are used to interrupt the
/// user with important information, requiring a decision or further action.
class WoltModalTypeDialog extends WoltModalType {
  const WoltModalTypeDialog()
      : super(
          shapeBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          isDragEnabled: false,
          shouldForceContentToMaxHeight: false,
        );

  @override
  String routeLabel(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.dialogLabel;
  }

  @override
  BoxConstraints modalContentBoxConstraints(Size availableSize) {
    return BoxConstraints(
      minWidth: min(availableSize.width, 480),
      maxWidth: min(availableSize.width, 480),
      minHeight: 0,
      maxHeight: availableSize.height * 0.9,
    );
  }

  @override
  Offset modalContentOffset(Size availableSize, Size modalContentSize) {
    return Offset(
      (availableSize.width - modalContentSize.width) / 2,
      (availableSize.height - modalContentSize.height) / 2,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: animation.drive(Tween(
        begin: 0.9,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.ease))),
      child: child,
    );
  }
}

/// Concrete implementation for a side sheet modal.
/// Side sheets are similar to side navigation drawers but may be used for additional contextual
/// information or actions related to the current view, sliding from the side of the screen.
class WoltSideSheetModal extends WoltModalType {
  const WoltSideSheetModal()
      : super(
          shapeBorder: const RoundedRectangleBorder(),
          isDragEnabled: false,
          isEndSafeAreaFilled: true,
          isTopSafeAreaFilled: true,
          isBottomSafeAreaFilled: true,
          shouldForceContentToMaxHeight: true,
        );

  @override
  String routeLabel(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.drawerLabel;
  }

  @override
  BoxConstraints modalContentBoxConstraints(Size availableSize) {
    return BoxConstraints(
      minWidth: 0,
      maxWidth: availableSize.width * 0.5,
      minHeight: availableSize.height,
      maxHeight: availableSize.height,
    );
  }

  @override
  Offset modalContentOffset(Size availableSize, Size modalContentSize) {
    return Offset(availableSize.width - modalContentSize.width, 0);
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
