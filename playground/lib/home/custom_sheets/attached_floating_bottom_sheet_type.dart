import 'dart:math';

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
    final renderBox =
        anchorKey.currentContext?.findRenderObject() as RenderBox?;
    _anchorPosition = renderBox?.localToGlobal(Offset.zero);
    _anchorSize = renderBox?.size;
  }

  late final Offset? _anchorPosition;
  late final Size? _anchorSize;
  final Alignment alignment;

  @override
  Offset positionModal(
      Size availableSize, Size modalContentSize, TextDirection textDirection) {
    final anchorPosition = _anchorPosition;
    final isOffscreen = anchorPosition == null ||
        anchorPosition.dx < 0 ||
        anchorPosition.dx > availableSize.width ||
        anchorPosition.dy < 0 ||
        anchorPosition.dy > availableSize.height;
    if (isOffscreen) {
      // Return the Center Offset by the size of the modal content
      // If no position found
      return availableSize.center(Offset.zero) -
          Offset(modalContentSize.width, modalContentSize.height) / 2;
    } else {
      final modalOffset = Offset(
        (alignment.x / 2 + 0.5) * modalContentSize.width,
        (alignment.y / 2 + 0.5) * modalContentSize.height,
      );
      final anchorSize = _anchorSize ?? Size.zero;

      final anchorOffset = Offset(
        (alignment.x / 2 + 0.5) * anchorSize.width,
        (alignment.y / 2 + 0.5) * anchorSize.height,
      );

      // Position the Modal based on Anchor Position plus the
      return anchorPosition + anchorOffset - modalOffset;
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

    // Calculate Available Space based on Anchor Position
    final double availableWidth;
    final double availableHeight;
    final position = _anchorPosition;

    if (position == null) {
      availableWidth = availableSize.width;
      availableHeight = availableSize.height;
    } else {
      if (alignment.x == -1 || alignment.x == 1) {
        if (alignment.x == 1) {
          // Modal is Left of the Anchor
          availableWidth = position.dx;
        } else {
          // Modal is Right of the Anchor
          availableWidth = availableSize.width - position.dx;
        }
      } else {
        availableWidth = min(position.dx, availableSize.width - position.dx);
      }

      if (alignment.y == -1 || alignment.y == 1) {
        if (alignment.y == 1) {
          // Modal is Top of the Anchor
          availableHeight = position.dy;
        } else {
          // Modal is Bottom of the Anchor
          availableHeight = availableSize.height - position.dy;
        }
      } else {
        availableHeight = min(position.dy, availableSize.height - position.dy);
      }
    }

    double width = availableWidth > 523.0 ? 312.0 : availableWidth - padding;

    if (availableWidth > 312) {
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
      maxHeight: min(availableHeight, availableSize.height * 0.8),
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
