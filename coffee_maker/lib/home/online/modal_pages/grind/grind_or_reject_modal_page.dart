import 'package:coffee_maker/entities/coffee_maker_step.dart';
import 'package:coffee_maker/home/online/view_model/store_online_view_model.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class GrindOrRejectModalPage {
  GrindOrRejectModalPage._();

  static WoltModalSheetPage build({required String coffeeOrderId}) {
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
            Builder(builder: (context) {
              final model = context.read<StoreOnlineViewModel>();
              return WoltElevatedButton(
                onPressed: () {
                  model.onCoffeeOrderStatusChange(
                      coffeeOrderId, CoffeeMakerStep.addWater);
                  Navigator.pop(context);
                },
                child: const Text('Start grinding'),
              );
            }),
          ],
        ),
      ),
      pageTitle: ModalSheetTitle(
        'Are you ready to prepare order $coffeeOrderId?',
        textAlign: TextAlign.center,
      ),
      trailingNavBarWidget: const WoltModalSheetCloseButton(),
      child: const Padding(
        padding: EdgeInsets.only(bottom: (2 * WoltElevatedButton.defaultHeight) + 48),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child:
              ModalSheetContentText('Accept the order to proceed to grinding'),
        ),
      ),
    );
  }
}
