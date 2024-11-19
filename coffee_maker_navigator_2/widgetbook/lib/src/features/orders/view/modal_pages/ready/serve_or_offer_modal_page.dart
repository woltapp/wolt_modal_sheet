import 'package:coffee_maker_navigator_2/features/orders/ui/view/modal_pages/ready/offer_recommendation_modal_page.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/modal_pages/ready/serve_or_offer_modal_page.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

@UseCase(
  name: 'ServeOrOfferModalPage',
  type: ServeOrOfferModalPage,
  path: 'Orders/View/ModalPages/Ready',
)
Widget serveOrOfferModalPage(BuildContext context) {
  return Scaffold(
    body: Center(
      child: WoltElevatedButton(
        onPressed: () {
          WoltModalSheet.show(
            context: context,
            pageListBuilder: (context) => [
              ServeOrOfferModalPage(
                coffeeOrderId: '123',
                onCoffeeOrderServed: () {},
              ),
            ],
          );
        },
        child: const Text('Open ServeOrOfferModalPage'),
      ),
    ),
  );
}
