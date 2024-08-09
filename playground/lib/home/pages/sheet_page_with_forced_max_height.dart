import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:playground/home/pages/modal_page_name.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithForcedMaxHeight {
  SheetPageWithForcedMaxHeight._();

  static const ModalPageName pageId = ModalPageName.forcedMaxHeight;

  static WoltModalSheetPage build(
    Brightness brightness, {
    bool isLastPage = true,
  }) {
    return WoltModalSheetPage(
      id: pageId,
      backgroundColor: brightness == Brightness.light
          ? WoltColors.green8
          : WoltColors.green64,
      hasSabGradient: false,
      forceMaxHeight: true,
      stickyActionBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Builder(builder: (context) {
          return WoltElevatedButton(
            onPressed: isLastPage
                ? Navigator.of(context).pop
                : WoltModalSheet.of(context).showNext,
            colorName: WoltColorName.green,
            child: Text(isLastPage ? "Close" : "Next"),
          );
        }),
      ),
      pageTitle: const ModalSheetTitle(
          'Page with forced max height and background color'),
      leadingNavBarWidget: const WoltModalSheetBackButton(),
      trailingNavBarWidget: const WoltModalSheetCloseButton(),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('''
This page height is forced to be the max height according to the provided max height ratio regardless of the intrinsic height of the child widget. 
'''),
      ),
    );
  }
}
