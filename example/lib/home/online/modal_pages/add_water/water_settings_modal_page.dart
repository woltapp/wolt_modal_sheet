import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:example/home/online/modal_pages/add_water/widgets/water_quantity_temperature_input.dart';
import 'package:example/home/online/modal_pages/add_water/widgets/water_source_list.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WaterSettingsModalPage {
  WaterSettingsModalPage._();

  static WoltModalSheetPage build({
    required VoidCallback onBackButtonPressed,
    required VoidCallback onClosed,
    required VoidCallback onWaterAdded,
  }) {
    final buttonEnabledListener = ValueNotifier(false);
    const pageTitle = 'Water settings';

    return WoltModalSheetPage.withSingleChild(
      footer: ValueListenableBuilder(
        valueListenable: buttonEnabledListener,
        builder: (_, enabled, __) {
          return StickyActionBarWrapper(
            child: WoltElevatedButton(
              onPressed: onWaterAdded,
              enabled: enabled,
              child: const Text('Finish adding water'),
            ),
          );
        },
      ),
      topBarTitle: const ModalSheetTopBarTitle(pageTitle),
      pageTitle: const ModalSheetTitle(pageTitle),
      closeButton: WoltModalSheetCloseButton(onClosed: onClosed),
      backButton: WoltModalSheetBackButton(onBackPressed: onBackButtonPressed),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ModalSheetSubtitle('Water quantity'),
            WaterQuantityTemperatureInput(
              suffixText: 'ml',
              controller: TextEditingController(),
              scrollPadding: const EdgeInsets.only(top: 100),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: WaterSourceList(
                onWaterSourceSelected: (source) => buttonEnabledListener.value = source.isSelected,
              ),
            ),
            const ModalSheetSubtitle('Water temperature'),
            WaterQuantityTemperatureInput(
              suffixText: '°C',
              controller: TextEditingController(),
              scrollPadding: const EdgeInsets.only(top: 100),
            ),
          ],
        ),
      ),
    );
  }
}
