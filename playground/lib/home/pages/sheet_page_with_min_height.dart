import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:playground/home/pages/modal_page_name.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithMinHeight {
  SheetPageWithMinHeight._();

  static const ModalPageName pageId = ModalPageName.minHeight;

  static WoltModalSheetPage build() {
    return WoltModalSheetPage(
      id: pageId,
      hasTopBarLayer: false,
      stickyActionBar: const Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: WoltModalSheetCloseOrNextSab(),
      ),
      child: const Padding(
        padding: EdgeInsets.only(bottom: 100, top: 16, left: 16, right: 16),
        child: ModalSheetContentText(
            'This page is added to test the constraints for minimum height.'),
      ),
    );
  }
}
