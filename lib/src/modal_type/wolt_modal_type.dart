import 'package:flutter/material.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

/// Enum representing the type of the modal.
enum WoltModalType {
  bottomSheet,
  dialog;

  const WoltModalType();

  /// Returns the y offset of the modal content based on the total [totalHeight] and [modalHeight].
  ///
  /// The [totalHeight] represents the total available height for the modal.
  /// The [modalHeight] represents the height of the modal content.
  double yOffsetOfModalContent(double totalHeight, double modalHeight) {
    switch (this) {
      case WoltModalType.bottomSheet:
        return totalHeight - modalHeight;
      case WoltModalType.dialog:
        return (totalHeight - modalHeight) / 2;
    }
  }
}
