import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';

class ErrorNotificationWidget extends StatelessWidget {
  final String message;

  const ErrorNotificationWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: WoltColors.red8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child:
                  Text(message, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}
