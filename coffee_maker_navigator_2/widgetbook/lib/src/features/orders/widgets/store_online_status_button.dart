import 'package:coffee_maker_navigator_2/features/orders/ui/widgets/store_online_status_button.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'StoreOnlineStatusButton',
  type: StoreOnlineStatusButton,
  path: 'Orders/Widgets',
)
Widget storeOnlineStatusButton(BuildContext context) {
  return Center(
    child: StoreOnlineStatusButton(
      isStoreOnlineNotifier: ValueNotifier(
        context.knobs.boolean(
          label: 'Store Online Status',
          description: 'Whether the store is online',
          initialValue: false,
        ),
      ),
    ),
  );
}
