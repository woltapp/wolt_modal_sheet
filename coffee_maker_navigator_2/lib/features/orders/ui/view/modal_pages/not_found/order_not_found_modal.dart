import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/widgets.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class OrderNotFoundModal extends WoltModalSheetPage {
  OrderNotFoundModal(
    String id,
    CoffeeMakerStep step,
  ) : super(
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: (WoltElevatedButton.defaultHeight + 32)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ModalSheetContentText(
                'The order you are looking for does not exist in ${step.stepName} step, or in a '
                'different state. Please check the order id and try again. If you need help, '
                'do not hesitate to contact us.',
              ),
            ),
          ),
          heroImage: const Image(
            image: AssetImage('assets/images/order_not_found.webp',
                package: 'assets'),
            fit: BoxFit.cover,
          ),
          pageTitle: ModalSheetTitle(
            'Order $id not found',
            textAlign: TextAlign.center,
          ),
          stickyActionBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Builder(builder: (context) {
              return WoltElevatedButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Close'),
              );
            }),
          ),
          trailingNavBarWidget: const WoltModalSheetCloseButton(),
        );
}
