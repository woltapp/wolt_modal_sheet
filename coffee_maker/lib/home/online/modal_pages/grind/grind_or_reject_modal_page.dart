import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class GrindOrRejectModalPage {
  GrindOrRejectModalPage._();

  static WoltModalSheetPage build({
    required String coffeeOrderId,
    required VoidCallback onGrindCoffeeTapped,
  }) {
    return WoltModalSheetPage(
      stickyActionBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            Builder(builder: (context) {
              return WoltElevatedButton(
                onPressed: WoltModalSheet.of(context).showNext,
                theme: WoltElevatedButtonTheme.secondary,
                colorName: WoltColorName.red,
                child: const Text('Reject order'),
              );
            }),
            const SizedBox(height: 8),
            WoltElevatedButton(
              onPressed: onGrindCoffeeTapped,
              child: const Text('Start grinding'),
            ),
          ],
        ),
      ),
      pageTitle: ModalSheetTitle(
        'Are you ready to prepare order $coffeeOrderId?',
        textAlign: TextAlign.center,
      ),
      trailingNavBarWidget: const WoltModalSheetCloseButton(),
      child: const Padding(
        padding: EdgeInsets.only(
            bottom: (2 * WoltElevatedButton.defaultHeight) + 48),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child:
              ModalSheetContentText('Accept the order to proceed to grinding'),
        ),
      ),
    );
  }
}
