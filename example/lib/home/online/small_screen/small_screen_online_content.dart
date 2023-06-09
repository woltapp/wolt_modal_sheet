import 'package:flutter/material.dart';
import 'package:example/constants/demo_app_colors.dart';
import 'package:example/entities/coffee_maker_step.dart';
import 'package:example/entities/grouped_coffee_orders.dart';
import 'package:example/home/online/widgets/coffee_order_list_widget.dart';
import 'package:example/home/online/small_screen/small_screen_bottom_navigation_bar.dart';
import 'package:example/home/widgets/top_bar.dart';

/// A widget that represents the online content for small screens.
///
/// This widget is responsible for displaying the coffee order lists for different steps of the coffee making process.
/// It takes a map of [CoffeeMakerStep] to [CoffeeOrderListWidget] as input, which defines the widgets for each step.
/// The [_isStoreOnlineNotifier] is a [ValueNotifier] that notifies the widget of changes in the store's online status.
/// The [_groupedCoffeeOrders] represents the grouped coffee orders in different states.
class SmallScreenOnlineContent extends StatefulWidget {
  const SmallScreenOnlineContent({
    required Map<CoffeeMakerStep, CoffeeOrderListWidget> coffeeMakerStepListWidgets,
    required ValueNotifier<bool> isStoreOnlineNotifier,
    required GroupedCoffeeOrders groupedCoffeeOrders,
    super.key,
  })  : _groupedCoffeeOrders = groupedCoffeeOrders,
        _coffeeMakerStepListWidgets = coffeeMakerStepListWidgets,
        _isStoreOnlineNotifier = isStoreOnlineNotifier;

  final ValueNotifier<bool> _isStoreOnlineNotifier;
  final Map<CoffeeMakerStep, CoffeeOrderListWidget> _coffeeMakerStepListWidgets;
  final GroupedCoffeeOrders _groupedCoffeeOrders;

  @override
  State<SmallScreenOnlineContent> createState() => _SmallScreenOnlineContentState();
}

class _SmallScreenOnlineContentState extends State<SmallScreenOnlineContent> {
  CoffeeMakerStep _selectedStepForBottomNavigationBar = CoffeeMakerStep.grind;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              selectedStepForBottomNavigationBar: _selectedStepForBottomNavigationBar,
              isStoreOnlineNotifier: widget._isStoreOnlineNotifier,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: DemoAppColors.black4,
                child: widget._coffeeMakerStepListWidgets[_selectedStepForBottomNavigationBar]!,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SmallScreenBottomNavigationBar(
        groupedCoffeeOrders: widget._groupedCoffeeOrders,
        selectedStep: _selectedStepForBottomNavigationBar,
        onSelected: (selectedStep) {
          setState(() {
            _selectedStepForBottomNavigationBar = selectedStep;
          });
        },
      ),
    );
  }
}
