import 'package:coffee_maker_navigator_2/ui/orders/view/orders_screen.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ServeOrOfferModalPage {
  ServeOrOfferModalPage._();

  static WoltModalSheetPage build(
      OnCoffeeOrderStatusChange onCoffeeOrderStatusChange,
      String coffeeOrderId) {
    return WoltModalSheetPage(
      heroImage: const Image(
        image: AssetImage('lib/assets/images/coffee_is_ready.png'),
        fit: BoxFit.cover,
      ),
      stickyActionBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            Builder(builder: (context) {
              return WoltElevatedButton(
                onPressed: () {
                  onCoffeeOrderStatusChange(coffeeOrderId);
                  Navigator.pop(context);
                },
                theme: WoltElevatedButtonTheme.secondary,
                child: const Text('Serve coffee'),
              );
            }),
            const SizedBox(height: 8),
            Builder(builder: (context) {
              return WoltElevatedButton(
                onPressed: WoltModalSheet.of(context).showNext,
                child: const Text('Offer recommendations'),
              );
            }),
          ],
        ),
      ),
      pageTitle: const ModalSheetTitle('The coffee is ready!'),
      trailingNavBarWidget: const WoltModalSheetCloseButton(),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 150),
        child: ModalSheetContentText(
          'Before serving, consider offering the customer some recommended additions',
        ),
      ),
    );
  }
}
