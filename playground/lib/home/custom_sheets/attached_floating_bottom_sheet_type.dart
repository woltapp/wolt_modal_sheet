import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// A [WoltModalType] that displays a floating bottom sheet which is dynamically positioned
/// relative to an anchor widget identified by [anchorKey]. This modal type allows for a
/// customizable presentation of content in relation to a specific UI element, enhancing
/// contextual awareness for the user.
///
/// ## Usage
/// This modal type is designed to be used when there is a need to display information or
/// actions related to a specific element on the screen. For example, it can be used to
/// show detailed information about an item in a list or to present actions related to
/// a specific UI component.
///
/// ## Positioning
/// The modal is positioned based on the location and size of the anchor widget.
/// The best anchor alignment is automatically calculated to maximize the available space
///
/// The modal automatically adjusts its size and position to ensure it fits within the
/// available screen space while respecting the specified alignment relative to the anchor
/// widget. This behavior ensures that the modal remains accessible and visually connected
/// to the context it relates to.
///
/// ## Considerations
/// - The [anchorKey] must be applied to a widget that is already in the widget tree for the
///   modal to position itself correctly.
///
/// Created by ABausG (https://github.com/abausg)
class AttachedFloatingBottomSheetType extends WoltModalType {
  static const Duration _defaultEnterDuration = Duration(milliseconds: 350);
  static const Duration _defaultExitDuration = Duration(milliseconds: 300);

  /// Creates an AttachedFloatingBottomSheetType
  ///
  /// [anchorKey] is the key of the widget that the bottom sheet will be attached to. Apply this key to the Widget where the Sheet should be attached to
  /// [_alignment] is the alignment of the bottom sheet to the anchor. Default is [Alignment.center]
  ///
  /// If the anchor is not found, the bottom sheet will be centered on the screen
  AttachedFloatingBottomSheetType({
    required GlobalKey anchorKey,
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
  Alignment _alignment = Alignment.center;

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
        (_alignment.x / 2 + 0.5) * modalContentSize.width,
        (_alignment.y / 2 + 0.5) * modalContentSize.height,
      );
      final anchorSize = _anchorSize ?? Size.zero;

      final anchorOffset = Offset(
        (_alignment.x / 2 + 0.5) * anchorSize.width,
        (_alignment.y / 2 + 0.5) * anchorSize.height,
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
    const padding = 4.0;

    // Calculate Available Space based on Anchor Position
    final double availableWidth;
    final double availableHeight;
    final position = _anchorPosition;

    if (position == null) {
      availableWidth = availableSize.width;
      availableHeight = availableSize.height;
    } else {
      final anchorCenter =
          position + (_anchorSize ?? Size.zero).center(Offset.zero);

      // Calculate alignment to maximize the available space
      double alignmentX = 0.0;
      double alignmentY = 0.0;

      final availableCenter = availableSize.center(Offset.zero);

      if (anchorCenter.dx < availableCenter.dx) {
        alignmentX = -1.0;
      } else if (anchorCenter.dx > availableCenter.dx) {
        alignmentX = 1.0;
      }

      if (anchorCenter.dy < availableCenter.dy) {
        alignmentY = -1.0;
      } else if (anchorCenter.dy > availableCenter.dy) {
        alignmentY = 1.0;
      }

      _alignment = Alignment(alignmentX, alignmentY);

      if (_alignment.x == -1 || _alignment.x == 1) {
        if (_alignment.x == 1) {
          // Modal is Left of the Anchor
          availableWidth = position.dx;
        } else {
          // Modal is Right of the Anchor
          availableWidth = availableSize.width - position.dx;
        }
      } else {
        availableWidth = min(position.dx, availableSize.width - position.dx);
      }

      if (_alignment.y == -1 || _alignment.y == 1) {
        if (_alignment.y == 1) {
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

    final width = min(availableWidth - padding, 312.0);
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
      curve: Curves.easeInOutCubic,
    ));

    return FadeTransition(
      opacity: alphaAnimation,
      child: child,
    );
  }
}
