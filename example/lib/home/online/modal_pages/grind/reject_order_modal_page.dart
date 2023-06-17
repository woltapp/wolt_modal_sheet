import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:example/home/online/modal_pages/grind/reject_order_reason.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class RejectOrderModalPage {
  RejectOrderModalPage._();

  static WoltModalSheetPage build({
    required VoidCallback onCoffeeOrderRejected,
    required VoidCallback onBackButtonPressed,
    required VoidCallback onClosed,
  }) {
    final buttonEnabledListener = ValueNotifier(false);

    return WoltModalSheetPage.withSingleChild(
      footer: ValueListenableBuilder(
        valueListenable: buttonEnabledListener,
        builder: (_, enabled, __) {
          return StickyActionBarWrapper(
            child: WoltElevatedButton(
              onPressed: onCoffeeOrderRejected,
              theme: WoltElevatedButtonTheme.secondary,
              colorName: WoltColorName.red,
              enabled: enabled,
              child: const Text('Reject'),
            ),
          );
        },
      ),
      pageTitle: const ModalSheetTitle('Reject order'),
      closeButton: WoltModalSheetCloseButton(onClosed: onClosed),
      backButton: WoltModalSheetBackButton(onBackPressed: onBackButtonPressed),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: ModalSheetContentText('Please select a reason for rejecting the order'),
            ),
            WoltSelectionList<RejectOrderReason>.singleSelect(
              itemTileDataGroup: WoltSelectionListItemDataGroup(
                group: RejectOrderReason.values
                    .map(
                      (e) => WoltSelectionListItemData(
                        title: e.title,
                        subtitle: e.subtitle,
                        leadingIcon: e.leadingIcon,
                        value: e,
                        isSelected: false,
                      ),
                    )
                    .toList(),
              ),
              onSelectionUpdateInSingleSelectionList: (selectedItemData) {
                buttonEnabledListener.value = selectedItemData.isSelected;
              },
            ),
          ],
        ),
      ),
    );
  }
}
