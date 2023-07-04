import 'package:coffee_maker/constants/demo_app_colors.dart';
import 'package:coffee_maker/entities/coffee_maker_step.dart';
import 'package:coffee_maker/home/online/widgets/coffee_order_list_widget.dart';
import 'package:flutter/material.dart';

/// A section that displays a list of coffee orders on a large screen.
///
/// This section consists of a header and a list of coffee orders.
/// The header displays the coffee maker step and the count of orders in that step.
/// The list of coffee orders is provided by the [_coffeeOrderListWidget].
class LargeScreenCoffeeOrderListSection extends StatelessWidget {
  const LargeScreenCoffeeOrderListSection({
    super.key,
    required CoffeeOrderListWidget coffeeOrderListWidget,
    required CoffeeMakerStep coffeeMakerStep,
  })  : _coffeeMakerStep = coffeeMakerStep,
        _coffeeOrderListWidget = coffeeOrderListWidget;

  final CoffeeOrderListWidget _coffeeOrderListWidget;
  final CoffeeMakerStep _coffeeMakerStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LargeScreenCoffeeOrderListHeader(
          coffeeMakerStep: _coffeeMakerStep,
          count: _coffeeOrderListWidget.coffeeOrders.length,
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: _coffeeMakerStep == CoffeeMakerStep.ready ? DemoAppColors.white : null,
            decoration: _coffeeMakerStep == CoffeeMakerStep.ready
                ? null
                : const ShapeDecoration(
                    color: DemoAppColors.black4,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: DemoAppColors.white, width: 2),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        topLeft: Radius.circular(16),
                      ),
                    ),
                  ),
            child: _coffeeOrderListWidget,
          ),
        ),
      ],
    );
  }
}

/// The header for the large screen coffee order list section.
///
/// This header displays the coffee maker step and the count of orders in that step.
class _LargeScreenCoffeeOrderListHeader extends StatelessWidget {
  const _LargeScreenCoffeeOrderListHeader(
      {required CoffeeMakerStep coffeeMakerStep, required int count})
      : _count = count,
        _coffeeMakerStep = coffeeMakerStep;

  final CoffeeMakerStep _coffeeMakerStep;
  final int _count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      decoration: const ShapeDecoration(
        shape: StadiumBorder(side: BorderSide(color: DemoAppColors.gray, width: 2)),
        color: DemoAppColors.white,
      ),
      child: Text(
        '${_coffeeMakerStep.stepName} ($_count)',
        style: Theme.of(context).textTheme.titleMedium!,
        textAlign: TextAlign.center,
      ),
    );
  }
}
