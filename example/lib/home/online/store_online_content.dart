import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:example/entities/coffee_maker_step.dart';
import 'package:example/entities/grouped_coffee_orders.dart';
import 'package:example/home/online/large_screen/large_screen_online_content.dart';
import 'package:example/home/online/modal_pages/add_water/add_water_modal_page_builder.dart';
import 'package:example/home/online/modal_pages/grind/grind_modal_page_builder.dart';
import 'package:example/home/online/modal_pages/ready/ready_modal_page_builder.dart';
import 'package:example/home/online/small_screen/small_screen_online_content.dart';
import 'package:example/home/online/view_model/store_online_view_model.dart';
import 'package:example/home/online/widgets/coffee_order_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

typedef OnCoffeeOrderStatusChange = Function(String coffeeOrderId, [CoffeeMakerStep? newStep]);

class StoreOnlineContent extends StatefulWidget {
  const StoreOnlineContent({
    required GroupedCoffeeOrders groupedCoffeeOrders,
    super.key,
  }) : _groupedCoffeeOrders = groupedCoffeeOrders;

  final GroupedCoffeeOrders _groupedCoffeeOrders;

  @override
  State<StoreOnlineContent> createState() => _StoreOnlineContentState();
}

class _StoreOnlineContentState extends State<StoreOnlineContent> {
  Map<CoffeeMakerStep, CoffeeOrderListWidget> _getCoffeeMakerStepListWidgets(BuildContext context) {
    final model = context.read<StoreOnlineViewModel>();

    return {
      CoffeeMakerStep.grind: CoffeeOrderListWidget(
        coffeeOrders: model.groupedCoffeeOrders.grindStateOrders,
        coffeeMakerStep: CoffeeMakerStep.grind,
        onCoffeeOrderSelected: (id) => _onCoffeeOrderSelectedInGrindState(context, id),
      ),
      CoffeeMakerStep.addWater: CoffeeOrderListWidget(
        coffeeOrders: model.groupedCoffeeOrders.addWaterStateOrders,
        coffeeMakerStep: CoffeeMakerStep.addWater,
        onCoffeeOrderSelected: (id) => _onCoffeeOrderSelectedInAddWaterState(context, id),
      ),
      CoffeeMakerStep.ready: CoffeeOrderListWidget(
        coffeeOrders: model.groupedCoffeeOrders.readyStateOrders,
        coffeeMakerStep: CoffeeMakerStep.ready,
        onCoffeeOrderSelected: (id) => _onCoffeeOrderSelectedInReadyState(context, id),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoreOnlineViewModel>(
      create: (context) =>
          StoreOnlineViewModel()..onInit(groupedCoffeeOrders: widget._groupedCoffeeOrders),
      child: Consumer<StoreOnlineViewModel>(
        builder: (context, model, _) {
          return WoltScreenWidthAdaptiveWidget(
            smallScreenWidthChild: SmallScreenOnlineContent(
              coffeeMakerStepListWidgets: _getCoffeeMakerStepListWidgets(context),
              groupedCoffeeOrders: model.groupedCoffeeOrders,
            ),
            largeScreenWidthChild: LargeScreenOnlineContent(
              coffeeMakerStepListWidgets: _getCoffeeMakerStepListWidgets(context),
            ),
          );
        },
      ),
    );
  }

  void _onCoffeeOrderSelectedInGrindState(BuildContext context, String coffeeOrderId) {
    final model = context.read<StoreOnlineViewModel>();
    final pageIndexNotifier = ValueNotifier(0);

    WoltModalSheet.show(
      pageIndexNotifier: pageIndexNotifier,
      context: context,
      pageListBuilderNotifier: ValueNotifier(
        GrindModalPageBuilder.build(
          coffeeOrderId: coffeeOrderId,
          goToPreviousPage: () => pageIndexNotifier.value = pageIndexNotifier.value - 1,
          goToNextPage: () => pageIndexNotifier.value = pageIndexNotifier.value + 1,
          onStartGrinding: () {
            model.onCoffeeOrderStatusChange(coffeeOrderId, CoffeeMakerStep.addWater);
            Navigator.pop(context);
          },
          onCoffeeOrderRejected: () {
            model.onCoffeeOrderStatusChange(coffeeOrderId);
            Navigator.pop(context);
          },
        ),
      ),
      modalTypeBuilder: (context) => _modalTypeBuilder(context),
    );
  }

  void _onCoffeeOrderSelectedInAddWaterState(BuildContext context, String coffeeOrderId) {
    final model = context.read<StoreOnlineViewModel>();
    final pageIndexNotifier = ValueNotifier(0);

    WoltModalSheet.show(
      pageIndexNotifier: pageIndexNotifier,
      context: context,
      pageListBuilderNotifier: ValueNotifier(
        AddWaterModalPageBuilder.build(
          coffeeOrderId: coffeeOrderId,
          goToPreviousPage: () => pageIndexNotifier.value = pageIndexNotifier.value - 1,
          goToNextPage: () => pageIndexNotifier.value = pageIndexNotifier.value + 1,
          onWaterAdded: () {
            model.onCoffeeOrderStatusChange(coffeeOrderId, CoffeeMakerStep.ready);
            Navigator.pop(context);
          },
          onCoffeeOrderCancelled: () {
            model.onCoffeeOrderStatusChange(coffeeOrderId);
            Navigator.pop(context);
          },
        ),
      ),
      modalTypeBuilder: (context) => _modalTypeBuilder(context),
    );
  }

  void _onCoffeeOrderSelectedInReadyState(BuildContext context, String coffeeOrderId) {
    final model = context.read<StoreOnlineViewModel>();

    final pageIndexNotifier = ValueNotifier(0);
    WoltModalSheet.show(
      pageIndexNotifier: pageIndexNotifier,
      context: context,
      pageListBuilderNotifier: ValueNotifier(
        ReadyModalPageBuilder.build(
          coffeeOrderId: coffeeOrderId,
          goToPreviousPage: () => pageIndexNotifier.value = pageIndexNotifier.value - 1,
          goToNextPage: () => pageIndexNotifier.value = pageIndexNotifier.value + 1,
          onCoffeeOrderServed: () {
            model.onCoffeeOrderStatusChange(coffeeOrderId);
            Navigator.pop(context);
          },
        ),
      ),
      modalTypeBuilder: (context) => _modalTypeBuilder(context),
    );
  }

  WoltModalType _modalTypeBuilder(BuildContext context) {
    switch (context.screenSize) {
      case WoltScreenSize.small:
        return WoltModalType.bottomSheet;
      case WoltScreenSize.large:
        return WoltModalType.dialog;
    }
  }
}
