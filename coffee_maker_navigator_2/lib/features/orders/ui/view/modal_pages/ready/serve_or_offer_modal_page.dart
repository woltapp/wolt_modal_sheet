import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ServeOrOfferModalPage extends WoltModalSheetPage {
  ServeOrOfferModalPage({
    required VoidCallback onCoffeeOrderServed,
    required String coffeeOrderId,
  }) : super(
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
                    onPressed: onCoffeeOrderServed,
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
