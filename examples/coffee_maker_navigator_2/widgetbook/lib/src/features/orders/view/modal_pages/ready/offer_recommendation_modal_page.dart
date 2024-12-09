import 'package:coffee_maker_navigator_2/features/orders/ui/view/modal_pages/ready/offer_recommendation_modal_page.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

@UseCase(
  name: 'OfferRecommendationModalPage',
  type: OfferRecommendationModalPage,
  path: 'Orders/View/ModalPages/Ready',
)
Widget offerRecommendationModalPage(BuildContext context) {
  return Scaffold(
    body: Center(
      child: WoltElevatedButton(
        onPressed: () {
          WoltModalSheet.show(
            context: context,
            pageListBuilder: (context) => [
              OfferRecommendationModalPage.build(
                coffeeOrderId: '123',
                onCoffeeOrderServed: () {},
              ),
            ],
          );
        },
        child: const Text('Open OfferRecommendationModalPage'),
      ),
    ),
  );
}
