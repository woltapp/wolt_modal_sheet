import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:playground/home/dynamic_page_properties.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithDynamicPageProperties {
  SheetPageWithDynamicPageProperties._();

  static WoltModalSheetPage build({
    required VoidCallback onSabPressed,
    required VoidCallback onBackPressed,
    required VoidCallback onClosed,
    required BuildContext context,
    bool isLastPage = true,
  }) {
    final dynamicPageModel = DynamicPageProperties.of(context)!;
    bool useOriginalPageValues = true;
    return WoltModalSheetPage.withSingleChild(
      hasSabGradient: false,
      enableDragForBottomSheet: dynamicPageModel.value.enableDragForBottomSheet,
      stickyActionBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: WoltElevatedButton(
          onPressed: onSabPressed,
          colorName: WoltColorName.green,
          child: Text(isLastPage ? "Close" : "Next"),
        ),
      ),
      isTopBarLayerAlwaysVisible: true,
      topBarTitle: const ModalSheetTopBarTitle('Dynamic page properties'),
      leadingNavBarWidget: WoltModalSheetBackButton(onBackPressed: onBackPressed),
      trailingNavBarWidget: WoltModalSheetCloseButton(onClosed: onClosed),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100),
        child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Row(
            children: [
              const Expanded(child: Text('Enable Drag for Bottom Sheet')),
              Switch(
                value: useOriginalPageValues,
                onChanged: (newValue) {
                  dynamicPageModel.value = dynamicPageModel.value.copyWith(
                    enableDragForBottomSheet: newValue,
                  );
                  setState(() => useOriginalPageValues = !useOriginalPageValues);
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
