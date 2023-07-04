import 'package:coffee_maker/entities/coffee_maker_step.dart';
import 'package:coffee_maker/home/widgets/coffee_maker_custom_divider.dart';
import 'package:coffee_maker/home/widgets/store_online_status_button.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

/// The top bar widget is displayed in both offline and online states of the Coffee Maker app.
///
/// The `TopBar` widget consists of a title and a store online status button.
/// The title represents the current screen or the name of the store, depending on the screen
/// size and store online status.
class TopBar extends StatelessWidget {
  const TopBar({
    required ValueNotifier<bool> isStoreOnlineNotifier,
    CoffeeMakerStep? selectedStepForBottomNavigationBar,
    super.key,
  })  : _isStoreOnlineNotifier = isStoreOnlineNotifier,
        _selectedStepForBottomNavigationBar = selectedStepForBottomNavigationBar;

  final CoffeeMakerStep? _selectedStepForBottomNavigationBar;
  final ValueNotifier<bool> _isStoreOnlineNotifier;

  @override
  Widget build(BuildContext context) {
    const store = 'Coffee Maker';
    final selectedStep = _selectedStepForBottomNavigationBar;
    late String title;
    switch (context.screenSize) {
      case WoltScreenSize.small:
        title =
            _isStoreOnlineNotifier.value && selectedStep != null ? selectedStep.stepName : store;
        break;
      case WoltScreenSize.large:
        title = store;
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16) - const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              StoreOnlineStatusButton(isStoreOnlineNotifier: _isStoreOnlineNotifier),
            ],
          ),
        ),
        const CoffeeMakerCustomDivider(),
      ],
    );
  }
}
