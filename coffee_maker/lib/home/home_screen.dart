import 'package:coffee_maker/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker/home/offline/store_offline_content.dart';
import 'package:coffee_maker/home/online/store_online_content.dart';
import 'package:flutter/material.dart';

/// The home screen of the CoffeeMaker demo app.
class HomeScreen extends StatefulWidget {
  /// Creates a new instance of [HomeScreen] widget.
  ///
  /// The [groupedCoffeeOrders] represents the grouped coffee orders to be displayed on the screen.
  /// The [isStoreOnline] indicates whether the store is currently in the online state.
  const HomeScreen({
    super.key,
    required GroupedCoffeeOrders groupedCoffeeOrders,
    required bool isStoreOnline,
  })  : _groupedCoffeeOrders = groupedCoffeeOrders,
        _isStoreOnline = isStoreOnline;

  final GroupedCoffeeOrders _groupedCoffeeOrders;
  final bool _isStoreOnline;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ValueNotifier<bool> _isStoreOnlineNotifier;

  @override
  void initState() {
    super.initState();
    _isStoreOnlineNotifier = ValueNotifier(widget._isStoreOnline);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isStoreOnlineNotifier,
      builder: (_, isStoreOnline, __) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isStoreOnline
              ? StoreOnlineContent(
                  groupedCoffeeOrders: widget._groupedCoffeeOrders,
                  isStoreOnlineNotifier: _isStoreOnlineNotifier,
                )
              : StoreOfflineContent(isStoreOnlineNotifier: _isStoreOnlineNotifier),
        );
      },
    );
  }
}
