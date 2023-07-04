import 'package:coffee_maker/home/online/modal_pages/ready/offer_recommendation_modal_page.dart';
import 'package:coffee_maker/home/online/modal_pages/ready/serve_or_offer_modal_page.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ReadyModalPageBuilder {
  ReadyModalPageBuilder._();

  static WoltModalSheetPageListBuilder build({
    required String coffeeOrderId,
    required VoidCallback goToNextPage,
    required VoidCallback goToPreviousPage,
    required VoidCallback onCoffeeOrderServed,
  }) {
    return (context) => [
          ServeOrOfferModalPage.build(
            onNextPage: goToNextPage,
            onServePressed: onCoffeeOrderServed,
            onClosed: Navigator.of(context).pop,
          ),
          OfferRecommendationModalPage.build(
            onBackButtonPressed: goToPreviousPage,
            onClosed: Navigator.of(context).pop,
            onCoffeeOrderServed: onCoffeeOrderServed,
          )
        ];
  }
}
