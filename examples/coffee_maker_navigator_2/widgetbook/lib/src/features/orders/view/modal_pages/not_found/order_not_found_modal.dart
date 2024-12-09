import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/modal_pages/not_found/order_not_found_modal.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

@UseCase(
  name: 'OrderNotFoundModal',
  type: OrderNotFoundModal,
  path: 'Orders/View/ModalPages/NotFound',
)
Widget rejectOrderModalPage(BuildContext context) {
  return Scaffold(
    body: Center(
      child: WoltElevatedButton(
        onPressed: () {
          WoltModalSheet.show(
            context: context,
            pageListBuilder: (context) => [
              OrderNotFoundModal(
                '123',
                CoffeeMakerStep.grind,
              ),
            ],
          );
        },
        child: const Text('Open OrderNotFoundModal'),
      ),
    ),
  );
}
