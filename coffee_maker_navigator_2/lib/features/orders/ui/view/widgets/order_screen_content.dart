import 'package:coffee_maker_navigator_2/app/ui/widgets/app_navigation_drawer.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/widgets/coffee_order_list_view_for_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/widgets/orders_screen_bottom_navigation_bar.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/widgets/top_bar.dart';
import 'package:coffee_maker_navigator_2/utils/extensions/context_extensions.dart';
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
    required this.selectedStepListenable,
    required this.groupedCoffeeOrders,
    required this.onBottomNavBarItemSelected,
  });

  final ValueListenable<CoffeeMakerStep> selectedStepListenable;
  final ValueListenable<GroupedCoffeeOrders> groupedCoffeeOrders;
  final OnOrderScreenBottomNavBarItemSelected onBottomNavBarItemSelected;

  @override
  Widget build(BuildContext context) {
    return SystemUIAnnotationWrapper(
      hasBottomNavigationBar: true,
      child: Scaffold(
        body: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: selectedStepListenable,
            builder: (context, selectedTab, _) {
              return Column(
                children: [
                  TopBar(selectedTab: selectedTab),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: groupedCoffeeOrders,
                      builder: (context, orders, _) {
                        final routerViewModel = context.routerViewModel;
                        return CoffeeOrderListViewForStep(
                          groupedCoffeeOrders: orders,
                          selectedBottomNavBarItem: selectedTab,
                          onGrindCoffeeStepSelected:
                              routerViewModel.onGrindCoffeeStepSelected,
                          onAddWaterCoffeeStepSelected:
                              routerViewModel.onAddWaterCoffeeStepSelected,
                          onReadyCoffeeStepSelected:
                              routerViewModel.onReadyCoffeeStepSelected,
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
          onBottomNavBarItemSelected,
          selectedStepListenable,
        ),
      ),
    );
  }
}
