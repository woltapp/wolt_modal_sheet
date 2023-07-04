import 'package:coffee_maker/entities/coffee_maker_step.dart';
import 'package:coffee_maker/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker/home/online/large_screen/large_screen_online_content.dart';
import 'package:coffee_maker/home/online/modal_pages/add_water/add_water_modal_page_builder.dart';
import 'package:coffee_maker/home/online/modal_pages/grind/grind_modal_page_builder.dart';
import 'package:coffee_maker/home/online/modal_pages/ready/ready_modal_page_builder.dart';
import 'package:coffee_maker/home/online/small_screen/small_screen_online_content.dart';
import 'package:coffee_maker/home/online/view_model/store_online_view_model.dart';
import 'package:coffee_maker/home/online/widgets/coffee_order_list_widget.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

typedef OnCoffeeOrderStatusChange = Function(String coffeeOrderId, [CoffeeMakerStep? newStep]);

class StoreOnlineContent extends StatefulWidget {
  const StoreOnlineContent({
    required GroupedCoffeeOrders groupedCoffeeOrders,
    required ValueNotifier<bool> isStoreOnlineNotifier,
    required ValueNotifier<bool> isGridOverlayVisibleNotifier,
    super.key,
  })  : _groupedCoffeeOrders = groupedCoffeeOrders,
        _isStoreOnlineNotifier = isStoreOnlineNotifier,
        _isGridOverlayVisibleNotifier = isGridOverlayVisibleNotifier;

  final GroupedCoffeeOrders _groupedCoffeeOrders;
  final ValueNotifier<bool> _isStoreOnlineNotifier;
  final ValueNotifier<bool> _isGridOverlayVisibleNotifier;

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
              isStoreOnlineNotifier: widget._isStoreOnlineNotifier,
            ),
            largeScreenWidthChild: LargeScreenOnlineContent(
              coffeeMakerStepListWidgets: _getCoffeeMakerStepListWidgets(context),
              isStoreOnlineNotifier: widget._isStoreOnlineNotifier,
              isGridOverlayVisibleNotifier: widget._isGridOverlayVisibleNotifier,
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
      pageListBuilderNotifier: GrindModalPageBuilder.build(
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
      modalTypeBuilder: _modalTypeBuilder,
    );
  }

  void _onCoffeeOrderSelectedInAddWaterState(BuildContext context, String coffeeOrderId) {
    final model = context.read<StoreOnlineViewModel>();
    final pageIndexNotifier = ValueNotifier(0);

    WoltModalSheet.show(
      pageIndexNotifier: pageIndexNotifier,
      context: context,
      decorator: (child) {
        return ChangeNotifierProvider<StoreOnlineViewModel>.value(
          value: model,
          builder: (_, __) => child,
        );
      },
      pageListBuilderNotifier: AddWaterModalPageBuilder.build(
        coffeeOrderId: coffeeOrderId,
        goToPreviousPage: () => pageIndexNotifier.value = pageIndexNotifier.value - 1,
        goToNextPage: () => pageIndexNotifier.value = pageIndexNotifier.value + 1,
      ),
      modalTypeBuilder: _modalTypeBuilder,
    );
  }

  void _onCoffeeOrderSelectedInReadyState(BuildContext context, String coffeeOrderId) {
    final model = context.read<StoreOnlineViewModel>();

    final pageIndexNotifier = ValueNotifier(0);
    WoltModalSheet.show(
      pageIndexNotifier: pageIndexNotifier,
      context: context,
      pageListBuilderNotifier: ReadyModalPageBuilder.build(
        coffeeOrderId: coffeeOrderId,
        goToPreviousPage: () => pageIndexNotifier.value = pageIndexNotifier.value - 1,
        goToNextPage: () => pageIndexNotifier.value = pageIndexNotifier.value + 1,
        onCoffeeOrderServed: () {
          model.onCoffeeOrderStatusChange(coffeeOrderId);
          Navigator.pop(context);
        },
      ),
      modalTypeBuilder: _modalTypeBuilder,
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
