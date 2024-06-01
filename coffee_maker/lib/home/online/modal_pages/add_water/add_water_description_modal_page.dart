import 'package:coffee_maker/home/online/view_model/store_online_view_model.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AddWaterDescriptionModalPage {
  AddWaterDescriptionModalPage._();

  static WoltModalSheetPage build(String coffeeOrderId) {
    return WoltModalSheetPage(
      heroImage: const Image(
        image: AssetImage('lib/assets/images/add_water_description.png'),
        fit: BoxFit.cover,
      ),
      stickyActionBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            Builder(builder: (context) {
              final model = context.read<StoreOnlineViewModel>();

              return WoltElevatedButton(
                onPressed: () {
                  model.onCoffeeOrderStatusChange(coffeeOrderId);
                  Navigator.pop(context);
                },
                theme: WoltElevatedButtonTheme.secondary,
                child: const Text('Cancel order'),
              );
            }),
            const SizedBox(height: 8),
            Builder(builder: (context) {
              return WoltElevatedButton(
                onPressed: WoltModalSheet.of(context).showNext,
                child: const Text('Continue to temperature'),
              );
            }),
          ],
        ),
      ),
      pageTitle: const ModalSheetTitle(
        'Adding water for coffee',
        textAlign: TextAlign.center,
      ),
      trailingNavBarWidget: Builder(builder: (context) {
        return WoltModalSheetCloseButton(onClosed: Navigator.of(context).pop);
      }),
      child: const Padding(
        padding: EdgeInsets.only(bottom: (2 * WoltElevatedButton.defaultHeight) + 8),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ModalSheetContentText(
            '''
The water you use is very important to the quality of your coffee. Use filtered or bottled water if your tap water is not good or has a strong odor or taste, such as chlorine.

If you’re using tap water, let it run a few seconds before filling your coffee pot, and be sure to use cold water. Avoid distilled or softened water.
''',
          ),
        ),
      ),
    );
  }
}
