import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/error_notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'ErrorNotificationWidget',
  type: ErrorNotificationWidget,
  path: 'Add Water/Widgets',
)
Widget errorNotificationWidget(BuildContext context) {
  return Scaffold(
    body: Center(
      child: ErrorNotificationWidget(
        context.knobs.string(
          label: 'Error Message',
          initialValue: 'Error message',
        ),
      ),
    ),
  );
}
