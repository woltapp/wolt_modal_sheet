import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithTextField {
  SheetPageWithTextField._();

  static WoltModalSheetPage build({
    required VoidCallback onSabPressed,
    required VoidCallback onBackPressed,
    required VoidCallback onClosed,
    bool isLastPage = true,
  }) {
    ValueNotifier<bool> isButtonEnabledNotifier = ValueNotifier(false);
    final textEditingController = TextEditingController();
    textEditingController.addListener(() {
      isButtonEnabledNotifier.value = textEditingController.text.isNotEmpty;
    });
    return WoltModalSheetPage.withSingleChild(
      stickyActionBar: ValueListenableBuilder<bool>(
        valueListenable: isButtonEnabledNotifier,
        builder: (_, isEnabled, __) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: WoltElevatedButton(
              onPressed: onSabPressed,
              enabled: isEnabled,
              child: Text(
                !isEnabled ? "Fill the text field to enable" : (isLastPage ? "Submit" : "Next"),
              ),
            ),
          );
        },
      ),
      topBarTitle: const ModalSheetTopBarTitle('Page with text field'),
      isTopBarLayerAlwaysVisible: true,
      leadingNavBarWidget: WoltModalSheetBackButton(onBackPressed: onBackPressed),
      trailingNavBarWidget: WoltModalSheetCloseButton(onClosed: onClosed),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80, top: 16, right: 16, left: 16),
        child: Column(
          children: [
            const ModalSheetContentText('''
This page has a text field and always visible top bar title. We wait for the keyboard closing before starting pagination. Don't forget to add a scroll padding to your text field to avoid the keyboard hiding the text field.
'''),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextFormField(
                autofocus: true,
                maxLines: 3,
                controller: textEditingController,
                scrollPadding: const EdgeInsets.only(top: 300),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
