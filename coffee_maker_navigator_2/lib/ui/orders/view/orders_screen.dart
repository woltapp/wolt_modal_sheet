import 'package:coffee_maker_navigator_2/domain/orders/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/domain/orders/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker_navigator_2/ui/extensions/context_extensions.dart';
import 'package:coffee_maker_navigator_2/ui/orders/di/orders_dependency_container.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/widgets/coffee_order_list_view_for_step.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/widgets/orders_screen_bottom_navigation_bar.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view_model/orders_screen_view_model.dart';
import 'package:coffee_maker_navigator_2/ui/orders/widgets/top_bar.dart';
import 'package:coffee_maker_navigator_2/ui/widgets/app_navigation_drawer.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wolt_di/wolt_di.dart';

typedef OnCoffeeOrderStatusChange = Function(String coffeeOrderId,
    [CoffeeMakerStep? newStep]);

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with
        FeatureWithViewModelDependencyContainerSubscriptionMixin<
            OrdersDependencyContainer, OrdersScreenViewModel, OrdersScreen> {
  ValueListenable<CoffeeMakerStep> get selectedStepListenable =>
      context.routerViewModel.bottomNavigationTabInOrdersPage;

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
                    child: _CoffeeStepList(
                      selectedTab,
                      viewModel.groupedCoffeeOrders,
                      viewModel.onCoffeeOrderStatusChange,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        drawer: const AppNavigationDrawer(selectedIndex: 0),
        bottomNavigationBar: _BottomNavigationBar(
          viewModel.groupedCoffeeOrders,
        ),
      ),
    );
  }
}

class _CoffeeStepList extends StatelessWidget {
  const _CoffeeStepList(
    this.selectedStep,
    this.groupedCoffeeOrders,
    this.onCoffeeOrderStatusChange,
  );

  final ValueListenable<GroupedCoffeeOrders> groupedCoffeeOrders;
  final OnCoffeeOrderStatusChange onCoffeeOrderStatusChange;
  final CoffeeMakerStep selectedStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ValueListenableBuilder(
        valueListenable:
            context.routerViewModel.bottomNavigationTabInOrdersPage,
        builder: (context, selectedTab, __) {
          return KeyedSubtree(
              key: PageStorageKey(selectedTab),
              child: ValueListenableBuilder(
                valueListenable: groupedCoffeeOrders,
                builder: (context, orders, _) {
                  return CoffeeOrderListViewForStep(
                    groupedCoffeeOrders: orders,
                    selectedStep: selectedStep,
                    onCoffeeOrderStatusChange: onCoffeeOrderStatusChange,
                  );
                },
              ));
        },
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar(this.groupedCoffeeOrders);

  final ValueListenable<GroupedCoffeeOrders> groupedCoffeeOrders;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.routerViewModel.bottomNavigationTabInOrdersPage,
      builder: (context, selectedTab, _) {
        return ValueListenableBuilder(
          valueListenable: groupedCoffeeOrders,
          builder: (context, orders, _) {
            return OrdersScreenBottomNavigationBar(
              groupedCoffeeOrders: orders,
              selectedStep: selectedTab,
              onSelected: (selectedStep) {
                context.routerViewModel
                    .onOrdersScreenBottomNavBarUpdated(selectedStep);
              },
            );
          },
        );
      },
    );
  }
}
