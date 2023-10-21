import 'package:coffee_maker/entities/coffee_maker_step.dart';
import 'package:flutter/material.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

/// A widget that displays a message when the coffee order list is empty for a specific coffee maker step.
///
/// This widget takes a coffee maker step and renders a message indicating that there are no tasks
/// or orders available for that step.
class EmptyCoffeeOrderList extends StatelessWidget {
  const EmptyCoffeeOrderList({
    super.key,
    required this.coffeeMakerStep,
  });

  final CoffeeMakerStep coffeeMakerStep;

  @override
  Widget build(BuildContext context) {
    return WoltScreenWidthAdaptiveWidget(
      largeScreenWidthChild: const SizedBox.shrink(),
      smallScreenWidthChild: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              coffeeMakerStep.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'New tasks will appear here automatically',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

extension _CoffeeMakerStepExtension on CoffeeMakerStep {
  String get title {
    switch (this) {
      case CoffeeMakerStep.grind:
        return 'No need to grind';
      case CoffeeMakerStep.addWater:
        return 'No need to addWater';
      case CoffeeMakerStep.ready:
        return 'Nothing ready yet';
    }
  }
}
