import 'dart:math';

import 'package:flutter/material.dart';

/// Enum representing the type of the modal.
enum WoltModalType {
  bottomSheet(
    isTopSafeAreaFilled: false,
    isBottomSafeAreaFilled: true,
    isStartSafeAreaFilled: false,
    isEndSafeAreaFilled: false,
  ),
  dialog(
    isTopSafeAreaFilled: false,
    isBottomSafeAreaFilled: true,
    isStartSafeAreaFilled: false,
    isEndSafeAreaFilled: false,
  );

  const WoltModalType({
    required this.isBottomSafeAreaFilled,
    required this.isTopSafeAreaFilled,
    required this.isStartSafeAreaFilled,
    required this.isEndSafeAreaFilled,
  });

  final bool isBottomSafeAreaFilled;
  final bool isTopSafeAreaFilled;
  final bool isStartSafeAreaFilled;
  final bool isEndSafeAreaFilled;

  /// Provides a semantic label for accessibility purposes based on the modal type.
  ///
  /// Accessibility labels help screen readers describe the function of the modal to users with
  /// visual impairments.
  ///
  /// Parameters:
  /// - [context]: The build context used to access MaterialLocalizations.
  ///
  /// The [totalWidth] represents the total available width for the modal.
  double modalContentWidth(
    double totalWidth, {
    required double minDialogWidth,
    required double maxDialogWidth,
  }) {
    double calculatedWidth;
    switch (this) {
      case WoltModalType.bottomSheet:
        return totalWidth;
      case WoltModalType.dialog:
        const totalColumnCount = 5;
        final columnWidth = totalWidth / totalColumnCount;
        calculatedWidth = 2 * columnWidth;
        return min(max(calculatedWidth, minDialogWidth), maxDialogWidth);
    }
  }

  /// Returns the x offset of the modal content based on the total [totalWidth].
  ///
  /// The [totalWidth] represents the total available width for the modal.
  double xOffsetOfModalContent(
    double totalWidth, {
    required double minDialogWidth,
    required double maxDialogWidth,
  }) {
    switch (this) {
      case WoltModalType.bottomSheet:
        return 0;
      case WoltModalType.dialog:
        return (totalWidth -
                modalContentWidth(
                  totalWidth,
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

  /// Returns the semantic label to be used for accessibility purposes based on the modal type.
  ///
  /// [context] is the BuildContext used to access MaterialLocalizations.
  String routeLabel(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    switch (this) {
      case WoltModalType.bottomSheet:
        // TODO: Add support for bottomSheetLabel once minimum supported version allows // return localizations.bottomSheetLabel;
        return localizations.dialogLabel;
      case WoltModalType.dialog:
        return localizations.dialogLabel;
    }
  }
}
