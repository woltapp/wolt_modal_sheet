import 'package:coffee_maker/constants/demo_app_colors.dart';
import 'package:coffee_maker/entities/coffee_maker_step.dart';
import 'package:coffee_maker/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker/home/widgets/coffee_maker_custom_divider.dart';
import 'package:flutter/material.dart';

typedef OnCoffeeMakerStepSelected = void Function(CoffeeMakerStep selectedStep);

/// A custom bottom navigation bar for the home screen.
///
/// This navigation bar displays icons representing different steps of the coffee making process.
/// It also shows the count of orders for each step, indicated by a badge.
/// The selected step is highlighted with a different color.
class SmallScreenBottomNavigationBar extends StatelessWidget {
  const SmallScreenBottomNavigationBar({
    required CoffeeMakerStep selectedStep,
    required void Function(CoffeeMakerStep) onSelected,
    required GroupedCoffeeOrders groupedCoffeeOrders,
    super.key,
  })  : _groupedCoffeeOrders = groupedCoffeeOrders,
        _onSelected = onSelected,
        _selectedStep = selectedStep;

  final CoffeeMakerStep _selectedStep;
  final OnCoffeeMakerStepSelected _onSelected;
  final GroupedCoffeeOrders _groupedCoffeeOrders;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CoffeeMakerCustomDivider(),
        NavigationBar(
          destinations: [
            for (CoffeeMakerStep step in CoffeeMakerStep.values)
              step._navigationDestination(
                  isSelected: step == _selectedStep,
                  count: _groupedCoffeeOrders.countForStep(step)),
          ],
          selectedIndex: _selectedStep.index,
          onDestinationSelected: (i) {
            _onSelected(
                CoffeeMakerStep.values.firstWhere((e) => e.stepNumber == i));
          },
        ),
      ],
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
        color: isSelected ? DemoAppColors.blue : DemoAppColors.black64);
    return count == 0
        ? icon
        : Badge(
            backgroundColor: DemoAppColors.red,
            label: Text(count.toString()),
            child: icon,
          );
  }
}
