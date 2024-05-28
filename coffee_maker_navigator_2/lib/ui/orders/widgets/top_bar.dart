import 'package:coffee_maker_navigator_2/domain/orders/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/ui/orders/widgets/coffee_maker_custom_divider.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    CoffeeMakerStep? selectedStepForBottomNavigationBar,
    Widget? trailing,
    super.key,
  })  : _selectedStepForBottomNavigationBar =
            selectedStepForBottomNavigationBar,
        _trailing = trailing;

  final CoffeeMakerStep? _selectedStepForBottomNavigationBar;
  final Widget? _trailing;

  @override
  Widget build(BuildContext context) {
    const store = 'Coffee Maker';
    final selectedStep = _selectedStepForBottomNavigationBar;
    late String title;
    switch (context.screenSize) {
      case WoltScreenSize.small:
        title = selectedStep?.stepName ?? store;
        break;
      case WoltScreenSize.large:
        title = store;
        break;
    }

    return ColoredBox(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.all(16) - const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const DrawerMenuButton(),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_trailing != null) _trailing!,
              ],
            ),
          ),
          const CoffeeMakerCustomDivider(),
        ],
      ),
    );
  }
}
