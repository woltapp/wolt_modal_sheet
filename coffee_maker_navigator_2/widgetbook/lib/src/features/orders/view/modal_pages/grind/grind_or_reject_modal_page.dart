import 'package:coffee_maker_navigator_2/features/orders/ui/view/modal_pages/grind/grind_or_reject_modal_page.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

@UseCase(
  name: 'GrindOrRejectModalPage',
  type: GrindOrRejectModalPage,
  path: 'Orders/View/ModalPages/Grind',
)
Widget grindOrRejectModalPage(BuildContext context) {
  return Scaffold(
    body: Center(
      child: WoltElevatedButton(
        onPressed: () {
          WoltModalSheet.show(
            context: context,
            pageListBuilder: (context) => [
              GrindOrRejectModalPage(
                coffeeOrderId: '123',
                onCoffeeOrderGrindCompleted: () {},
              ),
            ],
          );
        },
        child: const Text('Open GrindOrRejectModalPage'),
      ),
    ),
  );
}
