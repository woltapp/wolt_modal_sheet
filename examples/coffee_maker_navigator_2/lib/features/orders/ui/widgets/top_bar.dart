import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/widgets/coffee_maker_custom_divider.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    required CoffeeMakerStep selectedTab,
    super.key,
  }) : _selectedTab = selectedTab;

  final CoffeeMakerStep _selectedTab;

  @override
  Widget build(BuildContext context) {
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
                    _selectedTab.stepName,
                    style: Theme.of(context).textTheme.headlineMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const CoffeeMakerCustomDivider(),
        ],
      ),
    );
  }
}
