import 'package:coffee_maker_navigator_2/di/dependency_containers/orders_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/injector.dart';
import 'package:coffee_maker_navigator_2/di/dependency_container_subscriber.dart';
import 'package:coffee_maker_navigator_2/domain/orders/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/widgets/coffee_order_list_view_for_step.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/widgets/orders_screen_bottom_navigation_bar.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view_model/orders_screen_view_model.dart';
import 'package:coffee_maker_navigator_2/ui/orders/widgets/top_bar.dart';
import 'package:coffee_maker_navigator_2/ui/router/view_model/router_view_model.dart';
import 'package:coffee_maker_navigator_2/ui/widgets/app_navigation_drawer.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef OnCoffeeOrderStatusChange = Function(String coffeeOrderId,
    [CoffeeMakerStep? newStep]);

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with
        DependencyContainerSubscriber<OrdersDependencyContainer, OrdersScreen> {
  final List<Widget> _stepLists = [
    const GrindStepList(),
    const AddWaterStepList(),
    const ReadyStepList(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrdersScreenViewModel>(
      create: (context) => Injector.of(context)
          .getDependencyContainer<OrdersDependencyContainer>()
          .createOrderScreenViewModel(),
      builder: (context, _) {
        final viewModel = context.watch<OrdersScreenViewModel>();

        return SystemUIAnnotationWrapper(
          hasBottomNavigationBar: true,
          child: Builder(builder: (context) {
            final routerViewModel = context.watch<RouterViewModel>();
            final selectedBottomNavigationTab =
                routerViewModel.state.bottomNavigationTabInOrdersPage;

            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    TopBar(
                      selectedStepForBottomNavigationBar:
                          selectedBottomNavigationTab,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topCenter,
                        width: double.infinity,
                        height: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        color: WoltColors.black8,
                        child: IndexedStack(
                          index: selectedBottomNavigationTab.index,
                          children: _stepLists,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              drawer: const AppNavigationDrawer(selectedIndex: 0),
              bottomNavigationBar: OrdersScreenBottomNavigationBar(
                groupedCoffeeOrders: viewModel.groupedCoffeeOrders,
                selectedStep: selectedBottomNavigationTab,
                onSelected: (selectedStep) {
                  routerViewModel
                      .onOrdersScreenSelectedBottomNavBarUpdated(selectedStep);
                },
              ),
            );
          }),
        );
      },
    );
  }
}

class GrindStepList extends StatelessWidget {
  const GrindStepList({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrdersScreenViewModel>();

    return CoffeeOrderListViewForStep(
      groupedCoffeeOrders: viewModel.groupedCoffeeOrders,
      selectedStep: CoffeeMakerStep.grind,
    );
  }
}

class AddWaterStepList extends StatelessWidget {
  const AddWaterStepList({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrdersScreenViewModel>();

    return CoffeeOrderListViewForStep(
      groupedCoffeeOrders: viewModel.groupedCoffeeOrders,
      selectedStep: CoffeeMakerStep.addWater,
    );
  }
}

class ReadyStepList extends StatelessWidget {
  const ReadyStepList({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrdersScreenViewModel>();

    return CoffeeOrderListViewForStep(
      groupedCoffeeOrders: viewModel.groupedCoffeeOrders,
      selectedStep: CoffeeMakerStep.ready,
    );
  }
}
