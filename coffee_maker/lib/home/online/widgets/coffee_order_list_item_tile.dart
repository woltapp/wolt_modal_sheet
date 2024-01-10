import 'package:coffee_maker/constants/demo_app_colors.dart';
import 'package:coffee_maker/entities/coffee_order.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A tile widget representing a coffee order item in a list.
///
/// This tile displays the details of a coffee order, including the order ID, order name, and an action button.
/// The `onSelected` callback is invoked when the tile is tapped.
class CoffeeOrderListItemTile extends StatelessWidget {
  const CoffeeOrderListItemTile({
    super.key,
    required CoffeeOrder coffeeOrder,
    required void Function(String) onSelected,
  })  : _onSelected = onSelected,
        _coffeeOrder = coffeeOrder;

  final CoffeeOrder _coffeeOrder;
  final ValueChanged<String> _onSelected;

  VoidCallback get onTap {
    return () {
      if (kDebugMode) {
        print("Selected coffee order: ${_coffeeOrder.id}");
      }
      _onSelected(_coffeeOrder.id);
    };
  }

  @override
  Widget build(BuildContext context) {
    final step = _coffeeOrder.coffeeMakerStep;
    return SizedBox(
      height: 180,
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Stack(
              children: [
                Image(
                  image: AssetImage(step.assetName),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Container(color: DemoAppColors.black.withOpacity(0.3)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      _CoffeeOrderListItemDetails(
                        coffeeOrder: _coffeeOrder,
                        onTap: onTap,
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 56,
                        child: OutlinedButton(
                          onPressed: onTap,
                          child: Center(
                            child: Text(
                              step.actionName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The details section of a coffee order list item.
///
/// This section displays the order ID and order name of a coffee order.
class _CoffeeOrderListItemDetails extends StatelessWidget {
  const _CoffeeOrderListItemDetails({
    required CoffeeOrder coffeeOrder,
    required void Function() onTap,
  })  : _onTap = onTap,
        _coffeeOrder = coffeeOrder;

  final CoffeeOrder _coffeeOrder;
  final VoidCallback _onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton(
          onPressed: _onTap,
          child: Text(
            _coffeeOrder.id,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold, color: DemoAppColors.black),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _coffeeOrder.orderName,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: DemoAppColors.white,
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
