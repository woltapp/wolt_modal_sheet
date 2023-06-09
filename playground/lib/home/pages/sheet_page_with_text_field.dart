import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:playground/home/widget/sheet_title.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithTextField {
  SheetPageWithTextField._();

  static WoltModalSheetPage build({
    required VoidCallback onFooterPressed,
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
      padding: const EdgeInsetsDirectional.all(16),
      footer: ValueListenableBuilder<bool>(
        valueListenable: isButtonEnabledNotifier,
        builder: (_, isEnabled, __) {
          return WoltElevatedButton(
            onPressed: onFooterPressed,
            enabled: isEnabled,
            child: Text(
              !isEnabled ? "Fill the text field to enable" : (isLastPage ? "Submit" : "Next"),
            ),
          );
        },
      ),
      pageTitle: const SheetTitle('Page with text field'),
      backButton: WoltBackButton(onBackPressed: onBackPressed),
      closeButton: WoltCloseButton(onClosed: onClosed),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80, top: 16),
        child: Column(
          children: [
            const Text('''
This page has a text field. We wait for the keyboard closing before starting pagination. Don't forget to add a scroll padding to your text field to avoid the keyboard hiding the text field.
'''),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: WoltTextInput(
                labelText: 'This is a label',
                maxLines: 4,
                controller: textEditingController,
                scrollPadding: const EdgeInsets.only(top: WoltTextInput.woltTextInputHeight * 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
