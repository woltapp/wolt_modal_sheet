import 'package:coffee_maker/home/online/modal_pages/grind/grind_or_reject_modal_page.dart';
import 'package:coffee_maker/home/online/modal_pages/grind/reject_order_modal_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class GrindModalPageBuilder {
  GrindModalPageBuilder._();

  static WoltModalSheetPageListBuilder build({
    required String coffeeOrderId,
    required VoidCallback goToNextPage,
    required VoidCallback goToPreviousPage,
    required VoidCallback onStartGrinding,
    required VoidCallback onCoffeeOrderRejected,
  }) {
    return (context) => [
          GrindOrRejectModalPage.build(
            coffeeOrderId: coffeeOrderId,
            onRejectPressed: goToNextPage,
            onStartGrinding: onStartGrinding,
            onClosed: Navigator.of(context).pop,
          ),
          RejectOrderModalPage.build(
            onCoffeeOrderRejected: onCoffeeOrderRejected,
            onBackButtonPressed: goToPreviousPage,
            onClosed: Navigator.of(context).pop,
          ),
        ];
  }
}
