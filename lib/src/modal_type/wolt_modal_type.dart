import 'package:flutter/material.dart';

/// Enum representing the type of the modal.
enum WoltModalType {
  bottomSheet,
  dialog;

  const WoltModalType();

  /// Returns the [BorderRadiusGeometry] based on the specified [radiusAmount].
  ///
  /// The [radiusAmount] determines the amount of radius to be applied to the border.
  BorderRadiusGeometry borderRadiusGeometry(double radiusAmount) {
    final radius = Radius.circular(radiusAmount);
    switch (this) {
      case WoltModalType.bottomSheet:
        return BorderRadius.only(topLeft: radius, topRight: radius);
      case WoltModalType.dialog:
        return BorderRadius.all(radius);
    }
  }

  /// Returns the width of the modal content based on the total [totalWidth].
  ///
  /// The [totalWidth] represents the total available width for the modal.
  double modalContentWidth(double totalWidth) {
    switch (this) {
      case WoltModalType.bottomSheet:
        return totalWidth;
      case WoltModalType.dialog:
        return totalWidth - (2 * xOffsetOfModalContent(totalWidth));
    }
  }

  /// Returns the x offset of the modal content based on the total [totalWidth].
  ///
  /// The [totalWidth] represents the total available width for the modal.
  double xOffsetOfModalContent(double totalWidth) {
    switch (this) {
      case WoltModalType.bottomSheet:
        return 0;
      case WoltModalType.dialog:
        return 64;
    // return ResponsiveUiUtils.calculateWidthInResponsiveGridLayout(
    //   totalColumnCount: 8,
    //   columnCountInArea: 2,
    //   gutter: 8,
    //   totalWidth: totalWidth,
    // );
    }
  }

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
