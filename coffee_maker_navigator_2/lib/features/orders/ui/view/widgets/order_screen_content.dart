import 'package:coffee_maker_navigator_2/app/ui/widgets/app_navigation_drawer.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/widgets/coffee_order_list_view_for_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/widgets/orders_screen_bottom_navigation_bar.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/widgets/top_bar.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef OnCoffeeOrderUpdate = void Function(String coffeeOrderId);

typedef OnCoffeeOrderStatusChange = void Function(String coffeeOrderId,
    [CoffeeMakerStep? coffeeMakerStep]);

typedef OnOrderScreenBottomNavBarItemSelected = void Function(
    CoffeeMakerStep selectedStep);

class OrderScreenContent extends StatelessWidget {
  const OrderScreenContent({
    super.key,
    required this.selectedNavBarTabListenable,
    required this.groupedCoffeeOrders,
    required this.onNavBarItemSelected,
    required this.onGrindCoffeeStepSelected,
    required this.onAddWaterCoffeeStepSelected,
    required this.onReadyCoffeeStepSelected,
  });

  final ValueListenable<CoffeeMakerStep> selectedNavBarTabListenable;
  final ValueListenable<GroupedCoffeeOrders> groupedCoffeeOrders;
  final OnOrderScreenBottomNavBarItemSelected onNavBarItemSelected;
  final OnCoffeeOrderUpdate onGrindCoffeeStepSelected;
  final OnCoffeeOrderUpdate onAddWaterCoffeeStepSelected;
  final OnCoffeeOrderUpdate onReadyCoffeeStepSelected;

  @override
  Widget build(BuildContext context) {
    return SystemUIAnnotationWrapper(
      hasBottomNavigationBar: true,
      child: Scaffold(
        body: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: selectedNavBarTabListenable,
            builder: (context, selectedTab, _) {
              return Column(
                children: [
                  TopBar(selectedTab: selectedTab),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: groupedCoffeeOrders,
                      builder: (context, orders, _) {
                        return CoffeeOrderListViewForStep(
                          groupedCoffeeOrders: orders,
                          selectedBottomNavBarItem: selectedTab,
                          onGrindCoffeeStepSelected: onGrindCoffeeStepSelected,
                          onAddWaterCoffeeStepSelected:
                              onAddWaterCoffeeStepSelected,
                          onReadyCoffeeStepSelected: onReadyCoffeeStepSelected,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        drawer: const AppNavigationDrawer(selectedIndex: 0),
        bottomNavigationBar: OrdersScreenBottomNavigationBar(
          groupedCoffeeOrders,
          onNavBarItemSelected,
          selectedNavBarTabListenable,
        ),
      ),
    );
  }
}
