import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:playground/home/pages/custom_sheet_pages/adjust_time_notification_page.dart';
import 'package:playground/home/pages/custom_sheet_pages/reject_order_notification_page.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class NewOrderNotificationPage extends WoltModalSheetPage {
  NewOrderNotificationPage()
      : super(
          hasTopBarLayer: false,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Builder(builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ModalSheetTitle(
                    'Can you have the order ready in 34 minutes?',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const ModalSheetContentText(
                    'Suggested time is based on your average preparation time.',
                  ),
                  const SizedBox(height: 16),
                  WoltElevatedButton(
                    height: _buttonHeight,
                    onPressed: Navigator.of(context).pop,
                    child: const Text('Yes'),
                  ),
                  const SizedBox(height: 4),
                  WoltElevatedButton(
                    height: _buttonHeight,
                    onPressed: () {
                      WoltModalSheet.of(context)
                        ..addOrReplacePage(AdjustTimeNotificationPage())
                        ..showNext();
                    },
                    theme: WoltElevatedButtonTheme.secondary,
                    child: const Text('Adjust time'),
                  ),
                  const SizedBox(height: 4),
                  WoltElevatedButton(
                    height: _buttonHeight,
                    onPressed: () {
                      WoltModalSheet.of(context)
                        ..addOrReplacePage(RejectOrderNotificationPage())
                        ..showNext();
                    },
                    theme: WoltElevatedButtonTheme.secondary,
                    colorName: WoltColorName.red,
                    child: const Text('Reject order'),
                  ),
                ],
              );
            }),
          ),
        );

  static const double _buttonHeight = 24.0;
}
