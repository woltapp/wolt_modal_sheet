import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:playground/home/pages/modal_page_name.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithTextField {
  SheetPageWithTextField._();

  static const ModalPageName pageId = ModalPageName.textField;

  static WoltModalSheetPage build({bool isLastPage = true}) {
    ValueNotifier<bool> isButtonEnabledNotifier = ValueNotifier(false);
    final textEditingController = TextEditingController();
    textEditingController.addListener(() {
      isButtonEnabledNotifier.value = textEditingController.text.isNotEmpty;
    });
    return WoltModalSheetPage(
      id: pageId,
      stickyActionBar: ValueListenableBuilder<bool>(
        valueListenable: isButtonEnabledNotifier,
        builder: (context, isEnabled, __) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: WoltElevatedButton(
              onPressed: isLastPage
                  ? Navigator.of(context).pop
                  : WoltModalSheet.of(context).showNext,
              enabled: isEnabled,
              child: Text(
                !isEnabled
                    ? "Fill the text field to enable"
                    : (isLastPage ? "Submit" : "Next"),
              ),
            ),
          );
        },
      ),
      pageTitle: const ModalSheetTitle('Page with text field'),
      topBarTitle: const ModalSheetTopBarTitle('Page with text field'),
      leadingNavBarWidget: const WoltModalSheetBackButton(),
      trailingNavBarWidget: const WoltModalSheetCloseButton(),
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 80, top: 16, right: 16, left: 16),
        child: Column(
          children: [
            const ModalSheetContentText('''
This page has a text field and always visible top bar title. We wait for the keyboard closing before starting pagination. Don't forget to add a scroll padding to your text field to avoid the keyboard hiding the text field.
\n\n
This page has a text field and always visible top bar title. We wait for the keyboard closing before starting pagination. Don't forget to add a scroll padding to your text field to avoid the keyboard hiding the text field.
\n\n
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
