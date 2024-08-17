import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/orders_screen.dart';
import 'package:coffee_maker_navigator_2/utils/extensions/context_extensions.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class GrindOrRejectModalPage extends WoltModalSheetPage {
  GrindOrRejectModalPage(
    String coffeeOrderId,
    OnCoffeeOrderStatusChange onCoffeeOrderStatusChange,
  ) : super(
          child: const Padding(
            padding: EdgeInsets.only(
                bottom: (2 * WoltElevatedButton.defaultHeight) + 48),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: ModalSheetContentText(
                  'Accept the order to proceed to grinding'),
            ),
          ),
          pageTitle: ModalSheetTitle(
            'Are you ready to prepare order $coffeeOrderId?',
            textAlign: TextAlign.center,
          ),
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
                  return WoltElevatedButton(
                    onPressed: () {
                      onCoffeeOrderStatusChange(
                          coffeeOrderId, CoffeeMakerStep.addWater);
                      context.routerViewModel
                          .onGrindStepExit(hasStartedGrinding: true);
                    },
                    child: const Text('Start grinding'),
                  );
                }),
              ],
            ),
          ),
          trailingNavBarWidget: const WoltModalSheetCloseButton(),
        );
}
