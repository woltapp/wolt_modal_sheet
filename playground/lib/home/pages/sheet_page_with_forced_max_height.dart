import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithForcedMaxHeight {
  SheetPageWithForcedMaxHeight._();

  static WoltModalSheetPage build({
    required Brightness brightness,
    required VoidCallback onSabPressed,
    required VoidCallback onBackPressed,
    required VoidCallback onClosed,
    bool isLastPage = true,
  }) {
    return WoltModalSheetPage.withSingleChild(
      backgroundColor: brightness == Brightness.light ? WoltColors.green8 : WoltColors.green64,
      hasSabGradient: false,
      forceMaxHeight: true,
      stickyActionBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: WoltElevatedButton(
          onPressed: onSabPressed,
          colorName: WoltColorName.green,
          child: Text(isLastPage ? "Close" : "Next"),
        ),
      ),
      pageTitle: const ModalSheetTitle('Page with forced max height and background color'),
      leadingNavBarWidget: WoltModalSheetBackButton(onBackPressed: onBackPressed),
      trailingNavBarWidget: WoltModalSheetCloseButton(onClosed: onClosed),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('''
This page height is forced to be the max height according to the provided max height ratio regardless of the intrinsic height of the child widget. 
'''),
      ),
    );
  }
}
