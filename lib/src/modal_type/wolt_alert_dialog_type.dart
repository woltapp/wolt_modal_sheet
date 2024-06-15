import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WoltAlertDialogType extends WoltDialogType {
  const WoltAlertDialogType();

  @override
  BoxConstraints layoutModal(Size availableSize) {
    const padding = 32.0;
    final availableWidth = availableSize.width;
    double width = availableWidth > 523.0 ? 312.0 : availableWidth - padding;

    if (availableWidth > 523.0) {
      width = 312.0; // optimal width for larger screens
    } else if (availableWidth > 240.0) {
      width = 240.0; // standard width for moderate screens
    } else {
      width = availableWidth - padding; // adjust for very small screens
    }
    final height = availableSize.height * 0.8;

    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      minHeight: height,
      maxHeight: height,
    );
  }
}
