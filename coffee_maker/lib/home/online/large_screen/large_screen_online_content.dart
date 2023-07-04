import 'package:coffee_maker/entities/coffee_maker_step.dart';
import 'package:coffee_maker/home/online/large_screen/large_screen_coffee_order_list_section.dart';
import 'package:coffee_maker/home/online/widgets/coffee_order_list_widget.dart';
import 'package:coffee_maker/home/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

/// A widget that represents the online content for large screens.
///
/// This widget is responsible for displaying the coffee order lists for different steps of the coffee making process.
/// It takes a map of [CoffeeMakerStep] to [CoffeeOrderListWidget] as input, which defines the widgets for each step.
/// The [isStoreOnlineNotifier] is a [ValueNotifier] that notifies the widget of changes in the store's online status.
class LargeScreenOnlineContent extends StatefulWidget {
  const LargeScreenOnlineContent({
    required Map<CoffeeMakerStep, CoffeeOrderListWidget> coffeeMakerStepListWidgets,
    required ValueNotifier<bool> isStoreOnlineNotifier,
    required ValueNotifier<bool> isGridOverlayVisibleNotifier,
    super.key,
  })  : _coffeeMakerStepListWidgets = coffeeMakerStepListWidgets,
        _isStoreOnlineNotifier = isStoreOnlineNotifier,
        _isGridOverlayVisibleNotifier = isGridOverlayVisibleNotifier;

  final Map<CoffeeMakerStep, CoffeeOrderListWidget> _coffeeMakerStepListWidgets;
  final ValueNotifier<bool> _isStoreOnlineNotifier;
  final ValueNotifier<bool> _isGridOverlayVisibleNotifier;

  @override
  State<LargeScreenOnlineContent> createState() => _LargeScreenOnlineContentState();
}

class _LargeScreenOnlineContentState extends State<LargeScreenOnlineContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopBar(
              isStoreOnlineNotifier: widget._isStoreOnlineNotifier,
              isGridOverlayVisibleNotifier: widget._isGridOverlayVisibleNotifier,
            ),
            Expanded(
              child: WoltResponsiveLayoutGrid(
                margin: 8,
                gutter: 8,
                isOverlayVisible: widget._isGridOverlayVisibleNotifier.value,
                columnSpanCells: [
                  WoltColumnSpanCell(
                    columnSpan: 3,
                    columnCellWidget: LargeScreenCoffeeOrderListSection(
                      coffeeMakerStep: CoffeeMakerStep.grind,
                      coffeeOrderListWidget:
                          widget._coffeeMakerStepListWidgets[CoffeeMakerStep.grind]!,
                    ),
                  ),
                  WoltColumnSpanCell(
                    columnSpan: 3,
                    columnCellWidget: LargeScreenCoffeeOrderListSection(
                      coffeeMakerStep: CoffeeMakerStep.addWater,
                      coffeeOrderListWidget:
                          widget._coffeeMakerStepListWidgets[CoffeeMakerStep.addWater]!,
                    ),
                  ),
                  WoltColumnSpanCell(
                    columnSpan: 2,
                    columnCellWidget: LargeScreenCoffeeOrderListSection(
                      coffeeMakerStep: CoffeeMakerStep.ready,
                      coffeeOrderListWidget:
                          widget._coffeeMakerStepListWidgets[CoffeeMakerStep.ready]!,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
