import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class TopNotificationSheetType extends WoltModalType {
  final EdgeInsetsDirectional padding;

  const TopNotificationSheetType({
    this.padding = const EdgeInsetsDirectional.all(32.0),
  }) : super(
          shapeBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          dismissDirection: WoltModalDismissDirection.up,
          showDragHandle: false,
          closeProgressThreshold: 0.8,
          barrierDismissible: false,
        );

  @override
  String routeLabel(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.dialogLabel;
  }

  @override
  BoxConstraints layoutModal(Size availableSize) {
    final availableWidth = availableSize.width;
    double width =
        availableWidth > 523.0 ? 312.0 : availableWidth - padding.end;

    if (availableWidth > 523.0) {
      width = 312.0;
    } else if (availableWidth > 240.0) {
      width = 240.0;
    } else {
      width = availableWidth - padding.end;
    }
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      minHeight: 0,
      maxHeight: availableSize.height * 0.6,
    );
  }

  @override
  Offset positionModal(
      Size availableSize, Size modalContentSize, TextDirection textDirection) {
    final xOffset =
        max(0.0, (availableSize.width - modalContentSize.width) / 2);
    final yOffset = padding.top;
    return Offset(xOffset, yOffset);
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

    return FadeTransition(
      opacity: alphaAnimation,
      child: SlideTransition(
        position: animation.drive(
          Tween(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutQuad)),
        ),
        child: child,
      ),
    );
  }
}
