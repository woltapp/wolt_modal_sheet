import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:playground/home/pages/modal_page_name.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithNoPageTitleNoTopBar {
  SheetPageWithNoPageTitleNoTopBar._();

  static const ModalPageName pageId = ModalPageName.noTitleNoTopBar;

  static WoltModalSheetPage build({
    bool isLastPage = true,
  }) {
    return WoltModalSheetPage(
      id: pageId,
      backgroundColor: WoltColors.green8,
      forceMaxHeight: true,
      stickyActionBar: const Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: WoltModalSheetCloseOrNextSab(colorName: WoltColorName.green),
      ),
      hasTopBarLayer: false,
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '''
This page has a very long scrollable content and does not have a page title and top bar.
''',
            ),
            Placeholder(fallbackHeight: 2000, color: WoltColors.green),
          ],
        ),
      ),
    );
  }
}
