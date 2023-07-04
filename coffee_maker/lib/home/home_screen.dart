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
    required bool isGridOverlayVisible,
  })  : _groupedCoffeeOrders = groupedCoffeeOrders,
        _isStoreOnline = isStoreOnline,
        _isGridOverlayVisible = isGridOverlayVisible;

  final GroupedCoffeeOrders _groupedCoffeeOrders;
  final bool _isStoreOnline;
  final bool _isGridOverlayVisible;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ValueNotifier<bool> _isStoreOnlineNotifier;
  late ValueNotifier<bool> _isGridOverlayVisibleNotifier;

  @override
  void initState() {
    super.initState();
    _isStoreOnlineNotifier = ValueNotifier(widget._isStoreOnline);
    _isGridOverlayVisibleNotifier = ValueNotifier(widget._isGridOverlayVisible);
  }

  @override
  void dispose() {
    _isStoreOnlineNotifier.dispose();
    _isGridOverlayVisibleNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_isStoreOnlineNotifier, _isGridOverlayVisibleNotifier]),
      builder: (_, __) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isStoreOnlineNotifier.value
              ? StoreOnlineContent(
                  groupedCoffeeOrders: widget._groupedCoffeeOrders,
                  isStoreOnlineNotifier: _isStoreOnlineNotifier,
                  isGridOverlayVisibleNotifier: _isGridOverlayVisibleNotifier,
                )
              : StoreOfflineContent(
                  isStoreOnlineNotifier: _isStoreOnlineNotifier,
                  isGridOverlayVisibleNotifier: _isGridOverlayVisibleNotifier,
                ),
        );
      },
    );
  }
}
