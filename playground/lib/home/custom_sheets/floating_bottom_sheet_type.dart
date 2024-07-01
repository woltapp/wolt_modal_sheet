import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class FloatingBottomSheetType extends WoltModalType {
  final EdgeInsetsDirectional padding;
  static const Duration _defaultEnterDuration = Duration(milliseconds: 350);
  static const Duration _defaultExitDuration = Duration(milliseconds: 300);

  const FloatingBottomSheetType({
    this.padding = const EdgeInsetsDirectional.all(16.0),
  }) : super(
          shapeBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(28.0)),
          ),
          showDragHandle: false,
          dismissDirection: WoltModalDismissDirection.down,
          transitionDuration: _defaultEnterDuration,
          reverseTransitionDuration: _defaultExitDuration,
        );

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
  Offset positionModal(
      Size availableSize, Size modalContentSize, TextDirection textDirection) {
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
    final alphaAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 100.0 / 300.0, curve: Curves.linear),
      reverseCurve: const Interval(100.0 / 250.0, 1.0, curve: Curves.linear),
    ));

    final slideAnimation = Tween<Offset>(
      begin: const Offset(1, 1),
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
