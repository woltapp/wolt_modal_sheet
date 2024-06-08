import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class FloatingBottomSheet extends WoltModalType {
  final EdgeInsetsDirectional padding;

  const FloatingBottomSheet({
    this.padding = const EdgeInsetsDirectional.all(16.0),
  }) : super(
          shapeBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(28.0)),
          ),
          isDragEnabled: false,
        );

  @override
  String routeLabel(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.bottomSheetLabel;
  }

  @override
  BoxConstraints layoutModal(Size availableSize) {
    return BoxConstraints(
      minWidth: availableSize.width * 0.7,
      maxWidth: availableSize.width * 0.7,
      minHeight: 0,
      maxHeight: availableSize.height * 0.6,
    );
  }

  @override
  Offset positionModal(Size availableSize, Size modalContentSize) {
    // Custom position to align with the floating action button or near bottom right.
    return Offset(
      availableSize.width - modalContentSize.width - padding.end,
      availableSize.height - modalContentSize.height - padding.bottom,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: animation.drive(
          Tween(
            begin: const Offset(1.0, 1.0), // Starts from bottom right
            end: Offset.zero,
          ).chain(CurveTween(
              curve: Curves.easeOutCubic)), // Smooth and natural curve
        ),
        child: child,
      ),
    );
  }
}
