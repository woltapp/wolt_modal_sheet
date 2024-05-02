import 'package:coffee_maker_navigator_2/di/dependency_injection.dart';
import 'package:coffee_maker_navigator_2/domain/orders/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/widgets/coffee_order_list_view_for_step.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/widgets/orders_screen_bottom_navigation_bar.dart';
import 'package:coffee_maker_navigator_2/ui/widgets/app_navigation_drawer.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view_model/orders_screen_view_model.dart';
import 'package:coffee_maker_navigator_2/ui/orders/widgets/top_bar.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef OnCoffeeOrderStatusChange = Function(String coffeeOrderId,
    [CoffeeMakerStep? newStep]);

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    required this.initialBottomNavigationTab,
    super.key,
  });

  final CoffeeMakerStep initialBottomNavigationTab;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late CoffeeMakerStep _selectedBottomNavigationTab;

  @override
  void initState() {
    super.initState();
    _selectedBottomNavigationTab = widget.initialBottomNavigationTab;
  }

  @override
  void didUpdateWidget(covariant OrdersScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialBottomNavigationTab !=
        widget.initialBottomNavigationTab) {
      _selectedBottomNavigationTab = widget.initialBottomNavigationTab;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrdersScreenViewModel>(
      create: (context) =>
          DependencyInjection.get<OrdersScreenViewModel>()..onInit(),
      builder: (context, _) {
        final viewModel = context.watch<OrdersScreenViewModel>();

        return SystemUIAnnotationWrapper(
          hasBottomNavigationBar: true,
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  TopBar(
                    selectedStepForBottomNavigationBar:
                        _selectedBottomNavigationTab,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: WoltColors.black8,
                      child: CoffeeOrderListViewForStep(
                        groupedCoffeeOrders: viewModel.groupedCoffeeOrders,
                        selectedStep: _selectedBottomNavigationTab,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            drawer: const AppNavigationDrawer(selectedIndex: 0),
            bottomNavigationBar: OrdersScreenBottomNavigationBar(
              groupedCoffeeOrders: viewModel.groupedCoffeeOrders,
              selectedStep: _selectedBottomNavigationTab,
              onSelected: (selectedStep) {
                setState(() {
                  _selectedBottomNavigationTab = selectedStep;
                });
              },
            ),
          ),
        );
      },
    );
  }
}
