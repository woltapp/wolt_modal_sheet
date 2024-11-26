import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/widgets/order_screen_content.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/widgets/coffee_maker_custom_divider.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wolt_state_management/wolt_state_management.dart';

/// A custom bottom navigation bar for the home screen.
///
/// This navigation bar displays icons representing different steps of the coffee making process.
/// It also shows the count of orders for each step, indicated by a badge.
/// The selected step is highlighted with a different color.
class OrdersScreenBottomNavigationBar extends StatelessWidget {
  const OrdersScreenBottomNavigationBar(
    this.groupedCoffeeOrders,
    this.onBottomNavBarItemSelected,
    this.selectedBottomNavBarItem, {
    super.key,
  });

  final StatefulValueListenable<GroupedCoffeeOrders> groupedCoffeeOrders;
  final ValueListenable<CoffeeMakerStep> selectedBottomNavBarItem;
  final OnOrderScreenBottomNavBarItemSelected onBottomNavBarItemSelected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedBottomNavBarItem,
      builder: (context, selectedTab, _) {
        return StatefulValueListenableBuilder(
          valueListenable: groupedCoffeeOrders,
          idleBuilder: (BuildContext context, GroupedCoffeeOrders? orders) {
            if (orders == null) {
              return const SizedBox.shrink();
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const CoffeeMakerCustomDivider(),
                NavigationBar(
                  destinations: [
                    for (CoffeeMakerStep step in CoffeeMakerStep.values)
                      step._navigationDestination(
                          isSelected: step == selectedTab,
                          count: orders.countForStep(step)),
                  ],
                  selectedIndex: selectedTab.index,
                  onDestinationSelected: (i) {
                    final selectedTab = CoffeeMakerStep.values
                        .firstWhere((e) => e.stepNumber == i);
                    onBottomNavBarItemSelected(selectedTab);
                  },
                ),
              ],
            );
          },
          loadingBuilder: (BuildContext context, GroupedCoffeeOrders? value) {
            return const SizedBox.shrink();
          },
          errorBuilder: (BuildContext context, Object? error,
              GroupedCoffeeOrders? lastKnownValue) {
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

/// Represents data for a navigation destination.
class NavigationDestinationData {
  final Widget icon;
  final Widget selectedIcon;
  final String label;

  const NavigationDestinationData({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// An extension for [CoffeeMakerStep] to generate navigation destinations.
extension CoffeeMakerStepExtension on CoffeeMakerStep {
  NavigationDestination _navigationDestination({
    required bool isSelected,
    required int count,
  }) {
    switch (this) {
      case CoffeeMakerStep.grind:
        return NavigationDestination(
          icon: _DestinationIcon(
            Icons.add_circle_outline_outlined,
            isSelected: isSelected,
            count: count,
          ),
          selectedIcon: _DestinationIcon(
            Icons.add_circle_rounded,
            isSelected: isSelected,
            count: count,
          ),
          label: stepName,
        );
      case CoffeeMakerStep.addWater:
        return NavigationDestination(
          icon: _DestinationIcon(
            Icons.water_drop_outlined,
            isSelected: isSelected,
            count: count,
          ),
          selectedIcon: _DestinationIcon(
            Icons.water_drop_rounded,
            isSelected: isSelected,
            count: count,
          ),
          label: stepName,
        );
      case CoffeeMakerStep.ready:
        return NavigationDestination(
          icon: _DestinationIcon(
            Icons.coffee,
            isSelected: isSelected,
            count: count,
          ),
          selectedIcon: _DestinationIcon(
            Icons.coffee_rounded,
            isSelected: isSelected,
            count: count,
          ),
          label: stepName,
        );
    }
  }
}

/// A widget representing an icon for a navigation destination.
class _DestinationIcon extends StatelessWidget {
  const _DestinationIcon(
    this.iconData, {
    required this.isSelected,
    required this.count,
  });

  final IconData iconData;
  final bool isSelected;
  final int count;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(iconData,
        color: isSelected ? WoltColors.blue : WoltColors.black64);
    return count == 0
        ? icon
        : Badge(
            backgroundColor: WoltColors.red,
            label: Text(count.toString()),
            child: icon,
          );
  }
}
