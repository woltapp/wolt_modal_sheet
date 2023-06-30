import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:example/entities/coffee_maker_step.dart';
import 'package:example/entities/coffee_order.dart';
import 'package:example/entities/grouped_coffee_orders.dart';
import 'package:example/home/online/large_screen/large_screen_online_content.dart';
import 'package:example/home/online/modal_pages/add_water/add_water_modal_page_builder.dart';
import 'package:example/home/online/modal_pages/grind/grind_modal_page_builder.dart';
import 'package:example/home/online/modal_pages/ready/ready_modal_page_builder.dart';
import 'package:example/home/online/small_screen/small_screen_online_content.dart';
import 'package:example/home/online/widgets/coffee_order_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

typedef OnCoffeeOrderStatusChange = Function(String coffeeOrderId, [CoffeeMakerStep? newStep]);

class StoreOnlineContent extends StatefulWidget {
  const StoreOnlineContent({
    required GroupedCoffeeOrders groupedCoffeeOrders,
    required ValueNotifier<bool> isStoreOnlineNotifier,
    super.key,
  })  : _isStoreOnlineNotifier = isStoreOnlineNotifier,
        _groupedCoffeeOrders = groupedCoffeeOrders;

  final GroupedCoffeeOrders _groupedCoffeeOrders;
  final ValueNotifier<bool> _isStoreOnlineNotifier;

  @override
  State<StoreOnlineContent> createState() => _StoreOnlineContentState();
}

class _StoreOnlineContentState extends State<StoreOnlineContent> {
  late GroupedCoffeeOrders _orders;

  @override
  initState() {
    super.initState();
    _orders = widget._groupedCoffeeOrders;
  }

  Map<CoffeeMakerStep, CoffeeOrderListWidget> get _coffeeMakerStepListWidgets => {
        CoffeeMakerStep.grind: CoffeeOrderListWidget(
          coffeeOrders: _orders.grindStateOrders,
          coffeeMakerStep: CoffeeMakerStep.grind,
          onCoffeeOrderSelected: _onCoffeeOrderSelectedInGrindState,
        ),
        CoffeeMakerStep.addWater: CoffeeOrderListWidget(
          coffeeOrders: _orders.addWaterStateOrders,
          coffeeMakerStep: CoffeeMakerStep.addWater,
          onCoffeeOrderSelected: _onCoffeeOrderSelectedInAddWaterState,
        ),
        CoffeeMakerStep.ready: CoffeeOrderListWidget(
          coffeeOrders: _orders.readyStateOrders,
          coffeeMakerStep: CoffeeMakerStep.ready,
          onCoffeeOrderSelected: _onCoffeeOrderSelectedInReadyState,
        ),
      };

  @override
  Widget build(BuildContext context) {
    return WoltScreenWidthAdaptiveWidget(
      smallScreenWidthChild: SmallScreenOnlineContent(
        isStoreOnlineNotifier: widget._isStoreOnlineNotifier,
        coffeeMakerStepListWidgets: _coffeeMakerStepListWidgets,
        groupedCoffeeOrders: _orders,
      ),
      largeScreenWidthChild: LargeScreenOnlineContent(
        isStoreOnlineNotifier: widget._isStoreOnlineNotifier,
        coffeeMakerStepListWidgets: _coffeeMakerStepListWidgets,
      ),
    );
  }

  void _onCoffeeOrderSelectedInGrindState(coffeeOrderId) {
    final pageIndexNotifier = ValueNotifier(0);
    WoltModalSheet.show(
      pageIndexNotifier: pageIndexNotifier,
      context: context,
      defaultMaxDialogWidth: 560,
      pageListBuilderNotifier: ValueNotifier(
        GrindModalPageBuilder.build(
          coffeeOrderId: coffeeOrderId,
          goToPreviousPage: () => pageIndexNotifier.value = pageIndexNotifier.value - 1,
          goToNextPage: () => pageIndexNotifier.value = pageIndexNotifier.value + 1,
          onStartGrinding: () {
            _onCoffeeOrderStatusChange(coffeeOrderId, CoffeeMakerStep.addWater);
            Navigator.pop(context);
          },
          onCoffeeOrderRejected: () {
            _onCoffeeOrderStatusChange(coffeeOrderId);
            Navigator.pop(context);
          },
        ),
      ),
      modalTypeBuilder: (context) => _modalTypeBuilder(context),
    );
  }

  void _onCoffeeOrderSelectedInAddWaterState(coffeeOrderId) {
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
            _onCoffeeOrderStatusChange(coffeeOrderId, CoffeeMakerStep.ready);
            Navigator.pop(context);
          },
          onCoffeeOrderCancelled: () {
            _onCoffeeOrderStatusChange(coffeeOrderId);
            Navigator.pop(context);
          },
        ),
      ),
      modalTypeBuilder: (context) => _modalTypeBuilder(context),
    );
  }

  void _onCoffeeOrderSelectedInReadyState(coffeeOrderId) {
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
            _onCoffeeOrderStatusChange(coffeeOrderId);
            Navigator.pop(context);
          },
        ),
      ),
      modalTypeBuilder: (context) => _modalTypeBuilder(context),
    );
  }

  /// Callback method invoked when the status of a coffee order changes.
  ///
  /// The [coffeeOrderId] is the ID of the coffee order that had its status changed.
  /// The optional [newStep] parameter represents the new status of the coffee order.
  /// If [newStep] is provided and is either [CoffeeMakerStep.addWater] or [CoffeeMakerStep.ready],
  /// the method updates the status of the coffee order in the current list of orders.
  /// If [newStep] is not provided the method removes the coffee order from the current list of
  /// orders.
  /// Finally, the method triggers a state update to reflect the changes in the UI.
  void _onCoffeeOrderStatusChange(String coffeeOrderId, [CoffeeMakerStep? newStep]) {
    final currentList = List<CoffeeOrder>.from(_orders.allOrders);
    final updateIndex = currentList.indexWhere((o) => o.id == coffeeOrderId);
    if ([CoffeeMakerStep.addWater, CoffeeMakerStep.ready].contains(newStep)) {
      currentList[updateIndex] = currentList[updateIndex].copyWith(coffeeMakerStep: newStep);
    } else {
      currentList.removeAt(updateIndex);
    }
    setState(() {
      _orders = GroupedCoffeeOrders.fromCoffeeOrders(currentList);
    });
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
