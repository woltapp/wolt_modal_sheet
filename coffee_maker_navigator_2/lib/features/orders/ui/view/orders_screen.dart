import 'package:coffee_maker_navigator_2/features/orders/di/orders_dependency_container.dart';
import 'package:coffee_maker_navigator_2/features/orders/domain/entities/coffee_maker_step.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/widgets/order_screen_content.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view_model/orders_screen_view_model.dart';
import 'package:coffee_maker_navigator_2/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:wolt_di/wolt_di.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

/// STEP #4: Use DependencyContainerSubscriptionMixin to subscribe to the
/// dependency container. This mixin unsubscribes automatically when the
/// widget is disposed. DependencyContainerManager will take care of
/// disposing it if needed.
class _OrdersScreenState extends State<OrdersScreen>
    with
        DependencyContainerSubscriptionMixin<OrdersDependencyContainer,
            OrdersScreen> {
  late OrdersScreenViewModel viewModel;

  @override
  void initState() {
    super.initState();
    /// STEP #5: Create the view model using the dependency container.
    viewModel = DependencyInjector.container<OrdersDependencyContainer>(context)
        .createViewModel();
  }

  @override
  void dispose() {
    super.dispose();
    /// STEP #6: Dispose the viewmodel on dispose.
    viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routerViewModel = context.routerViewModel;

    return OrderScreenContent(
      selectedNavBarTabListenable: routerViewModel.visibleOrderScreenNavBarTab,
      onNavBarItemSelected: routerViewModel.onOrderScreenNavBarTabSelected,
      groupedCoffeeOrders: viewModel.groupedCoffeeOrders,
      onGrindCoffeeStepSelected: (id) =>
          routerViewModel.onOrderStepStarted(id, CoffeeMakerStep.grind),
      onAddWaterCoffeeStepSelected: (id) =>
          routerViewModel.onOrderStepStarted(id, CoffeeMakerStep.addWater),
      onReadyCoffeeStepSelected: (id) =>
          routerViewModel.onOrderStepStarted(id, CoffeeMakerStep.ready),
    );
  }
}
