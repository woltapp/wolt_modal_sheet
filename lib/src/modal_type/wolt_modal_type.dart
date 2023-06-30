import 'dart:math';

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
  double modalContentWidth({
    required double totalWidth,
    required double? minDialogWidth,
    required double? maxDialogWidth,
  }) {
    assert(totalWidth >= 0, 'totalWidth must be a non-negative value.');

    switch (this) {
      case WoltModalType.bottomSheet:
        return totalWidth;

      case WoltModalType.dialog:
        assert(minDialogWidth == null || minDialogWidth >= 0,
            'minDialogWidth must be a non-negative value if provided.');
        assert(maxDialogWidth == null || maxDialogWidth >= 0,
            'maxDialogWidth must be a non-negative value if provided.');
        assert(minDialogWidth == null || maxDialogWidth == null || minDialogWidth <= maxDialogWidth,
            'minDialogWidth must be less than or equal to maxDialogWidth.');

        const totalColumnCount = 4;
        final columnWidth = (totalWidth / totalColumnCount);
        final minimumWidth = minDialogWidth ?? columnWidth * 2;
        final maximumWidth = maxDialogWidth ?? columnWidth * 2;

        return min(maximumWidth, max(minimumWidth, totalWidth));
    }
  }

  /// Returns the x offset of the modal content based on the total [totalWidth].
  ///
  /// The [totalWidth] represents the total available width for the modal.
  double xOffsetOfModalContent({
    required double totalWidth,
    required double? minDialogWidth,
    required double? maxDialogWidth,
  }) {
    switch (this) {
      case WoltModalType.bottomSheet:
        return 0;
      case WoltModalType.dialog:
        return (totalWidth -
                modalContentWidth(
                  totalWidth: totalWidth,
                  minDialogWidth: minDialogWidth,
                  maxDialogWidth: maxDialogWidth,
                )) /
            2;
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
