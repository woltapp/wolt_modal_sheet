import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:playground/home/dynamic_page_properties.dart';
import 'package:playground/home/pages/modal_page_name.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// This is a page that is shown in the modal sheet to demonstrate how to change the page
/// properties dynamically.
class SheetPageWithDynamicPageProperties {
  SheetPageWithDynamicPageProperties._();

  static const ModalPageName pageId = ModalPageName.dynamicPageProperties;

  static WoltModalSheetPage build(BuildContext context,
      {bool isLastPage = true}) {
    bool useOriginalPageValues = true;
    return WoltModalSheetPage(
      id: pageId,
      hasSabGradient: false,
      enableDrag: DynamicPageProperties.of(context)?.value.enableDrag ?? false,
      stickyActionBar: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: WoltElevatedButton(
            onPressed: isLastPage
                ? Navigator.of(context).pop
                : WoltModalSheet.of(context).showNext,
            colorName: WoltColorName.green,
            child: Text(isLastPage ? "Close" : "Next"),
          ),
        );
      }),
      isTopBarLayerAlwaysVisible: true,
      topBarTitle: const ModalSheetTopBarTitle('Dynamic page properties'),
      leadingNavBarWidget: const WoltModalSheetBackButton(),
      trailingNavBarWidget: const WoltModalSheetCloseButton(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Row(
                    children: [
                      const Expanded(
                          child: Text('Enable Drag for Bottom Sheet')),
                      Switch(
                        value: useOriginalPageValues,
                        onChanged: (newValue) {
                          final dynamicPageModel =
                              DynamicPageProperties.of(context);
                          dynamicPageModel?.value =
                              dynamicPageModel.value.copyWith(
                            enableDrag: newValue,
                          );
                          setState(() =>
                              useOriginalPageValues = !useOriginalPageValues);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            const Placeholder(fallbackHeight: 1200, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
