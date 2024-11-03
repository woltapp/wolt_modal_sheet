import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/error_notification_widget.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wolt_state_management/wolt_state_management.dart';

class AddWaterScreenFooter extends StatelessWidget {
  const AddWaterScreenFooter({
    super.key,
    required this.isReadyToAddWater,
    required this.errorMessage,
    required this.onCheckValidity,
    required this.onAddWater,
    required this.onStepCompleted,
  });

  final StatefulValueListenable<bool> isReadyToAddWater;
  final StatefulValueListenable<String?> errorMessage;
  final VoidCallback onCheckValidity;
  final VoidCallback onAddWater;
  final VoidCallback onStepCompleted;

  void _handleAddWater() {
    onAddWater();
    onStepCompleted();
  }

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
              StatefulValueListenableBuilder<String?>(
                valueListenable: errorMessage,
                idleBuilder: (_, message) {
                  return message == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: ErrorNotificationWidget(message),
                        );
                },
                loadingBuilder: (_, __) => const SizedBox.shrink(),
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
              WoltElevatedButton(
                onPressed: onCheckValidity,
                child: const Text('Check'),
              ),
              const SizedBox(height: 12),
              StatefulValueListenableBuilder<bool>(
                valueListenable: isReadyToAddWater,
                idleBuilder: (_, isEnabled) {
                  return WoltElevatedButton(
                    enabled: isEnabled ?? false,
                    onPressed: _handleAddWater,
                    child: const Text('Add water'),
                  );
                },
                loadingBuilder: (_, __) => const CircularProgressIndicator(),
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
