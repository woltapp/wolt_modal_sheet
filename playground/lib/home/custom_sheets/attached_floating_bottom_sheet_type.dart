import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AttachedFloatingBottomSheetType extends WoltModalType {
  static const Duration _defaultEnterDuration = Duration(milliseconds: 350);
  static const Duration _defaultExitDuration = Duration(milliseconds: 300);

  AttachedFloatingBottomSheetType({
    required GlobalKey anchorKey,
    this.alignment = Alignment.center,
  }) : super(
          shapeBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(28.0)),
          ),
          showDragHandle: false,
          dismissDirection: WoltModalDismissDirection.down,
          transitionDuration: _defaultEnterDuration,
          reverseTransitionDuration: _defaultExitDuration,
        ) {
    _anchorPosition =
        (anchorKey.currentContext?.findRenderObject() as RenderBox?)
            ?.localToGlobal(Offset.zero);
  }

  late final Offset? _anchorPosition;
  final Alignment alignment;

  @override
  Offset positionModal(
      Size availableSize, Size modalContentSize, TextDirection textDirection) {
    final anchorPosition = _anchorPosition;
    if (anchorPosition == null) {
      // Return the Center Offset by the size of the modal content
      return availableSize.center(Offset.zero) -
          Offset(modalContentSize.width, modalContentSize.height) / 2;
    } else {
      final offsetPosition = anchorPosition -
          Offset(modalContentSize.width, modalContentSize.height) / 2 -
          Offset(alignment.x / 2 * modalContentSize.width,
              alignment.y / 2 * modalContentSize.height);

      return offsetPosition;
    }
  }

  @override
  String routeLabel(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.bottomSheetLabel;
  }

  @override
  BoxConstraints layoutModal(Size availableSize) {
    const padding = 32.0;
    final availableWidth = availableSize.width;
    double width = availableWidth > 523.0 ? 312.0 : availableWidth - padding;

    if (availableWidth > 523.0) {
      width = 312.0;
    } else if (availableWidth > 240.0) {
      width = 240.0;
    } else {
      width = availableWidth * 0.7;
    }

    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      minHeight: 0,
      maxHeight: availableSize.height * 0.8,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final alphaAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 100.0 / 300.0, curve: Curves.linear),
      reverseCurve: const Interval(100.0 / 250.0, 1.0, curve: Curves.linear),
    ));

    final slideAnimation = Tween<Offset>(
      begin: Offset(alignment.x, alignment.y),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
    ));

    final scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
    ));

    return FadeTransition(
      opacity: alphaAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: child,
        ),
      ),
    );
  }
}
