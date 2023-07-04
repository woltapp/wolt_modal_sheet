import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class GrindOrRejectModalPage {
  GrindOrRejectModalPage._();

  static WoltModalSheetPage build({
    required String coffeeOrderId,
    required VoidCallback onRejectPressed,
    required VoidCallback onStartGrinding,
    required VoidCallback onClosed,
  }) {
    return WoltModalSheetPage.withSingleChild(
      stickyActionBar: StickyActionBarWrapper(
        child: Column(
          children: [
            WoltElevatedButton(
              onPressed: onRejectPressed,
              theme: WoltElevatedButtonTheme.secondary,
              colorName: WoltColorName.red,
              child: const Text('Reject order'),
            ),
            const SizedBox(height: 8),
            WoltElevatedButton(
              onPressed: onStartGrinding,
              child: const Text('Start grinding'),
            ),
          ],
        ),
      ),
      pageTitle: ModalSheetTitle(
        'Are you ready to prepare order $coffeeOrderId?',
        textAlign: TextAlign.center,
      ),
      closeButton: WoltModalSheetCloseButton(onClosed: onClosed),
      child: const Padding(
        padding: EdgeInsets.only(bottom: (2 * WoltElevatedButton.height) + 48),
        child: ModalSheetContentText('Accept the order to proceed to grinding'),
      ),
    );
  }
}
