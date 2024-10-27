import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/error_notification_widget.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/widgets.dart';

class AddWaterScreenFooter extends StatelessWidget {
  const AddWaterScreenFooter({
    super.key,
    required this.isReadyToAddWater,
    required this.errorMessage,
    required this.onCheckValidity,
    required this.onAddWater,
    required this.onStepCompleted,
  });

  final bool isReadyToAddWater;
  final String? errorMessage;
  final VoidCallback onCheckValidity;
  final VoidCallback onAddWater;
  final VoidCallback onStepCompleted;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(16.0) +
              EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ErrorNotificationWidget(errorMessage!),
                ),
              WoltElevatedButton(
                onPressed: onCheckValidity,
                child: const Text('Check'),
              ),
              const SizedBox(height: 12),
              WoltElevatedButton(
                enabled: isReadyToAddWater,
                onPressed: () {
                  onAddWater();
                  onStepCompleted();
                },
                child: const Text('Add water'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
