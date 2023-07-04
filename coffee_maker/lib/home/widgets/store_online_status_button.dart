import 'package:coffee_maker/constants/demo_app_colors.dart';
import 'package:flutter/material.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

/// The `StoreOnlineStatusButton` widget displays a button indicating the online status of the store.
/// It is a toggle button that allows the user to switch the store between online and offline states.
class StoreOnlineStatusButton extends StatelessWidget {
  const StoreOnlineStatusButton({
    required ValueNotifier<bool> isStoreOnlineNotifier,
    super.key,
  }) : _isStoreOnlineNotifier = isStoreOnlineNotifier;

  final ValueNotifier<bool> _isStoreOnlineNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isStoreOnlineNotifier,
      builder: (_, isOnline, __) {
        return OutlinedButton(
          style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                side:
                    const MaterialStatePropertyAll(BorderSide(width: 2, color: DemoAppColors.gray)),
              ),
          onPressed: () {
            _isStoreOnlineNotifier.value = !_isStoreOnlineNotifier.value;
          },
          child: Row(
            children: <Widget>[
              SizedBox.square(
                  dimension: 12,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      shape: const CircleBorder(),
                      color: isOnline ? DemoAppColors.green : DemoAppColors.red,
                    ),
                  )),
              const SizedBox(width: 8),
              WoltScreenWidthAdaptiveWidget(
                smallScreenWidthChild: const Icon(
                  Icons.store,
                  size: 16,
                  color: DemoAppColors.black,
                ),
                largeScreenWidthChild: Text(isOnline ? 'Online' : 'Offline'),
              ),
            ],
          ),
        );
      },
    );
  }
}
