import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/error_notification_widget.dart';
import 'package:coffee_maker_navigator_2/utils/extensions/context_extensions.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AddWaterScreenFooter extends StatelessWidget {
  const AddWaterScreenFooter(
    this.isReadyToAddWater,
    this.errorMessage,
    this.onCheckValidity,
    this.onAddWater, {
    super.key,
  });

  final ValueListenable<bool> isReadyToAddWater;
  final ValueListenable<String?> errorMessage;
  final VoidCallback onCheckValidity;
  final VoidCallback onAddWater;

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
              ValueListenableBuilder<String?>(
                  valueListenable: errorMessage,
                  builder: (_, message, __) {
                    return message == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: ErrorNotificationWidget(message),
                          );
                  }),
              WoltElevatedButton(
                onPressed: onCheckValidity,
                child: const Text('Check '),
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<bool>(
                valueListenable: isReadyToAddWater,
                builder: (_, isEnabled, __) {
                  return WoltElevatedButton(
                    enabled: isEnabled,
                    onPressed: () {
                      onAddWater();
                      context.routerViewModel.onAddWaterStepCompleted();
                    },
                    child: const Text('Add water'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
