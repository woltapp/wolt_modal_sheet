import 'package:coffee_maker/entities/coffee_maker_step.dart';
import 'package:coffee_maker/home/online/modal_pages/add_water/add_water_description_modal_page.dart';
import 'package:coffee_maker/home/online/modal_pages/add_water/water_settings_modal_page.dart';
import 'package:coffee_maker/home/online/view_model/store_online_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AddWaterModalPageBuilder {
  AddWaterModalPageBuilder._();

  static WoltModalSheetPageListBuilder build({
    required String coffeeOrderId,
    required VoidCallback goToNextPage,
    required VoidCallback goToPreviousPage,
  }) {
    return (context) {
      final model = context.read<StoreOnlineViewModel>();

      return [
        AddWaterDescriptionModalPage.build(
          onNextPage: goToNextPage,
          onCancelPressed: () {
            model.onCoffeeOrderStatusChange(coffeeOrderId);
            Navigator.pop(context);
          },
          onClosed: Navigator.of(context).pop,
        ),
        WaterSettingsModalPage.build(
          onBackButtonPressed: goToPreviousPage,
          onClosed: Navigator.of(context).pop,
          onWaterAdded: () {
            model.onCoffeeOrderStatusChange(coffeeOrderId, CoffeeMakerStep.ready);
            Navigator.pop(context);
          },
        )
      ];
    };
  }
}
