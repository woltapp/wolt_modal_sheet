import 'package:coffee_maker_navigator_2/domain/orders/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/domain/orders/entities/coffee_order.dart';
import 'package:coffee_maker_navigator_2/domain/orders/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker_navigator_2/ui/extensions/context_extensions.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/modal_pages/ready/offer_recommendation_modal_page.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/modal_pages/ready/serve_or_offer_modal_page.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/orders_screen.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/widgets/coffee_order_list_item_tile.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/widgets/empty_coffee_order_list_view.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

/// A widget that displays a list of coffee orders for a specific coffee maker step.
///
/// This widget takes a list of coffee orders, a coffee maker step, and a callback function for when a coffee order is selected.
/// It renders either an empty list message or a scrollable list of coffee order items.
class CoffeeOrderListViewForStep extends StatelessWidget {
  const CoffeeOrderListViewForStep({
    super.key,
    required this.selectedStep,
    required this.groupedCoffeeOrders,
    required this.onCoffeeOrderStatusChange,
  });

  final CoffeeMakerStep selectedStep;
  final GroupedCoffeeOrders groupedCoffeeOrders;
  final OnCoffeeOrderStatusChange onCoffeeOrderStatusChange;

  static const String modalRouteSettingName = "stepModalRouteName";

  @override
  Widget build(BuildContext context) {
    switch (selectedStep) {
      case CoffeeMakerStep.grind:
        return _CoffeeOrderListView(
          coffeeOrders: groupedCoffeeOrders.grindStateOrders,
          coffeeMakerStep: CoffeeMakerStep.grind,
          onCoffeeOrderSelected: (id) {
            context.routerViewModel.onGrindStepEntering(
              id,
              onCoffeeOrderStatusChange(
                id,
                CoffeeMakerStep.addWater,
              ),
            );
          },
        );
      case CoffeeMakerStep.addWater:
        return _CoffeeOrderListView(
          coffeeOrders: groupedCoffeeOrders.addWaterStateOrders,
          coffeeMakerStep: CoffeeMakerStep.addWater,
          onCoffeeOrderSelected: (id) =>
              _onCoffeeOrderSelectedInAddWaterState(context, id),
        );
      case CoffeeMakerStep.ready:
        return _CoffeeOrderListView(
          coffeeOrders: groupedCoffeeOrders.readyStateOrders,
          coffeeMakerStep: CoffeeMakerStep.ready,
          onCoffeeOrderSelected: (id) => _onCoffeeOrderSelectedInReadyState(
              context, onCoffeeOrderStatusChange, id),
        );
    }
  }
}

void _onCoffeeOrderSelectedInAddWaterState(
    BuildContext context, String coffeeOrderId) {
  context.routerViewModel.onAddWaterStepEntering(coffeeOrderId);
}

void _onCoffeeOrderSelectedInReadyState(
  BuildContext context,
  OnCoffeeOrderStatusChange onCoffeeOrderStatusChange,
  String coffeeOrderId,
) {
  WoltModalSheet.show(
    settings: const RouteSettings(
        name: CoffeeOrderListViewForStep.modalRouteSettingName),
    context: context,
    pageListBuilder: (context) => [
      ServeOrOfferModalPage.build(onCoffeeOrderStatusChange, coffeeOrderId),
      OfferRecommendationModalPage.build(
          onCoffeeOrderStatusChange, coffeeOrderId)
    ],
    modalTypeBuilder: _modalTypeBuilder,
  );
}

WoltModalType _modalTypeBuilder(BuildContext context) {
  switch (context.screenSize) {
    case WoltScreenSize.small:
      return WoltModalType.bottomSheet();
    case WoltScreenSize.large:
      return WoltModalType.dialog();
  }
}

class _CoffeeOrderListView extends StatelessWidget {
  const _CoffeeOrderListView({
    required this.coffeeOrders,
    required CoffeeMakerStep coffeeMakerStep,
    required void Function(String) onCoffeeOrderSelected,
  })  : _onCoffeeOrderSelected = onCoffeeOrderSelected,
        _coffeeMakerStep = coffeeMakerStep;

  final List<CoffeeOrder> coffeeOrders;
  final CoffeeMakerStep _coffeeMakerStep;
  final ValueChanged<String> _onCoffeeOrderSelected;

  @override
  Widget build(BuildContext context) {
    return coffeeOrders.isEmpty
        ? EmptyCoffeeOrderList(coffeeMakerStep: _coffeeMakerStep)
        : ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView.separated(
              itemBuilder: (_, index) {
                final coffeeOrder = coffeeOrders[index];
                return Column(
                  children: [
                    if (index == 0) const SizedBox(height: 16),
                    CoffeeOrderListItemTile(
                      coffeeOrder: coffeeOrder,
                      onSelected: _onCoffeeOrderSelected,
                    ),
                    if (index == coffeeOrders.length - 1)
                      const SizedBox(height: 16),
                  ],
                );
              },
              itemCount: coffeeOrders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
            ),
          );
  }
}
