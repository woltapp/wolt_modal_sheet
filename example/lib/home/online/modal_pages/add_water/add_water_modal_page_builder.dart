import 'package:example/home/online/modal_pages/add_water/add_water_description_modal_page.dart';
import 'package:example/home/online/modal_pages/add_water/water_settings_modal_page.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AddWaterModalPageBuilder {
  AddWaterModalPageBuilder._();

  static WoltModalSheetPageListBuilder build({
    required String coffeeOrderId,
    required VoidCallback goToNextPage,
    required VoidCallback goToPreviousPage,
    required VoidCallback onWaterAdded,
    required VoidCallback onCoffeeOrderCancelled,
  }) {
    return (context) => [
          AddWaterDescriptionModalPage.build(
            onNextPage: goToNextPage,
            onCancelPressed: onCoffeeOrderCancelled,
            onClosed: Navigator.of(context).pop,
          ),
          WaterSettingsModalPage.build(
            onBackButtonPressed: goToPreviousPage,
            onClosed: Navigator.of(context).pop,
            onWaterAdded: onWaterAdded,
          )
        ];
  }
}
