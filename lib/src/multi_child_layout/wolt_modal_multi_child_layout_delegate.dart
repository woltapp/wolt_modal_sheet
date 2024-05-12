import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_modal_type.dart';

/// A custom [MultiChildLayoutDelegate] that handles the layout of the modal and barrier content within [WoltScrollableModalSheet].
class WoltModalMultiChildLayoutDelegate extends MultiChildLayoutDelegate {
  /// The maximum height percentage of the content relative to the available size.
  final double maxPageHeight;

  /// The minimum height percentage of the content relative to the available size.
  final double minPageHeight;

  final double minDialogWidth;

  final double maxDialogWidth;

  /// The layout identifier for the content.
  final String contentLayoutId;

  /// The layout identifier for the barrier.
  final String barrierLayoutId;

  /// The type of the scrollable modal.
  final WoltModalType modalType;

  /// The animation controller for drag behavior.
  final AnimationController? dragController;

  /// Whether the modal content can be dragged.
  final bool? enableDrag;

  /// Creates a [WoltModalMultiChildLayoutDelegate].
  ///
  /// [maxPageHeight] represents the maximum page height in the range of [0, 1] relative to the available size.
  ///
  /// [minPageHeight] represents the minimum page height in the range of [0, 1] relative to the available size.
  ///
  /// [contentLayoutId] represents the layout identifier for the content.
  ///
  /// [barrierLayoutId] represents the layout identifier for the barrier.
  ///
  /// [modalType] represents the type of the scrollable modal.
  ///
  /// [minDialogWidth] represents the minimum width of the dialog.
  ///
  /// [maxDialogWidth] represents the maximum width of the dialog.
  ///
  /// [dragController] represents the animation controller for drag behavior.
  ///
  /// [enableDrag] represents whether the modal content can be dragged.
  WoltModalMultiChildLayoutDelegate({
    required this.maxPageHeight,
    required this.minPageHeight,
    required this.contentLayoutId,
    required this.barrierLayoutId,
    required this.modalType,
    required this.minDialogWidth,
    required this.maxDialogWidth,
    this.dragController,
    this.enableDrag,
  }) : assert(enableDrag != true || dragController != null,
            'If enableDrag is true, animationController must not be null.');

  @override
  void performLayout(Size size) {
    final modalWidth = modalType.modalContentWidth(
      size.width,
      minDialogWidth: minDialogWidth,
      maxDialogWidth: maxDialogWidth,
    );
    layoutChild(
      barrierLayoutId,
      BoxConstraints(maxWidth: size.width, maxHeight: size.height),
    );
    double maxHeight = enableDrag == true
        ? (dragController!.value == 0.0
            ? size.height * maxPageHeight
            : dragController!.value * size.height)
        : size.height * maxPageHeight;

    final modalHeight = layoutChild(
      contentLayoutId,
      BoxConstraints(
        minHeight: size.height * minPageHeight,
        maxHeight: maxHeight,
        maxWidth: modalWidth,
        minWidth: modalWidth,
      ),
    ).height;
    if (enableDrag == true && dragController!.value == 0.0) {
      dragController!.value = modalHeight / size.height;
    }

    /// Position Modal Content
    positionChild(
      contentLayoutId,
      Offset(
        modalType.xOffsetOfModalContent(
          size.width,
          maxDialogWidth: maxDialogWidth,
          minDialogWidth: minDialogWidth,
        ),
        modalType.yOffsetOfModalContent(size.height, modalHeight),
      ),
    );

    /// Position Barrier
    positionChild(barrierLayoutId, Offset.zero);
  }

  /// Determines whether the delegate should re-layout the children based on changes in [modalType].
  @override
  bool shouldRelayout(covariant WoltModalMultiChildLayoutDelegate oldDelegate) {
    return oldDelegate.modalType != modalType ||
        oldDelegate.minDialogWidth != minDialogWidth ||
        oldDelegate.maxDialogWidth != maxDialogWidth ||
        oldDelegate.maxPageHeight != maxPageHeight ||
        oldDelegate.minPageHeight != minPageHeight;
  }
}
