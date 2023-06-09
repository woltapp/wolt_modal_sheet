import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_modal_type.dart';

/// A custom [MultiChildLayoutDelegate] that handles the layout of the modal and barrier content within [WoltScrollableModalSheet].
class WoltModalSheetMultiChildLayoutDelegate extends MultiChildLayoutDelegate {
  /// The maximum height percentage of the content relative to the available size.
  final double maxPageHeight;

  /// The minimum height percentage of the content relative to the available size.
  final double minPageHeight;

  /// The layout identifier for the content.
  final String contentLayoutId;

  /// The layout identifier for the barrier.
  final String barrierLayoutId;

  /// The type of the scrollable modal.
  final WoltModalType scrollableModalType;

  /// Creates a [WoltModalSheetMultiChildLayoutDelegate].
  ///
  /// [maxPageHeight] represents the maximum page height in the range of [0, 1] relative to the available size.
  ///
  /// [minPageHeight] represents the minimum page height in the range of [0, 1] relative to the available size.
  ///
  /// [contentLayoutId] represents the layout identifier for the content.
  ///
  /// [barrierLayoutId] represents the layout identifier for the barrier.
  ///
  /// [scrollableModalType] represents the type of the scrollable modal.
  WoltModalSheetMultiChildLayoutDelegate({
    required this.maxPageHeight,
    required this.minPageHeight,
    required this.contentLayoutId,
    required this.barrierLayoutId,
    required this.scrollableModalType,
  });

  @override
  void performLayout(Size size) {
    final modalWidth = scrollableModalType.modalContentWidth(size.width);
    layoutChild(
      barrierLayoutId,
      BoxConstraints(maxWidth: size.width, maxHeight: size.height),
    );
    final modalHeight = layoutChild(
      contentLayoutId,
      BoxConstraints(
        maxHeight: size.height * maxPageHeight,
        minHeight: size.height * minPageHeight,
        maxWidth: modalWidth,
        minWidth: modalWidth,
      ),
    ).height;

    /// Position Modal Content
    positionChild(
      contentLayoutId,
      Offset(
        scrollableModalType.xOffsetOfModalContent(size.width),
        scrollableModalType.yOffsetOfModalContent(size.height, modalHeight),
      ),
    );

    /// Position Barrier
    positionChild(barrierLayoutId, Offset.zero);
  }

  /// Determines whether the delegate should re-layout the children based on changes in [scrollableModalType].
  @override
  bool shouldRelayout(covariant WoltModalSheetMultiChildLayoutDelegate oldDelegate) {
    return oldDelegate.scrollableModalType != scrollableModalType;
  }
}
