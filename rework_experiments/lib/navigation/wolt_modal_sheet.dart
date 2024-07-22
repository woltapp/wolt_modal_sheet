import 'package:flutter/material.dart';
import 'package:rework_experiments/navigation/wolt_modal_sheet_coordinator.dart';
import 'package:rework_experiments/navigation/wolt_modal_sheet_path.dart';
import 'package:rework_experiments/navigation/wolt_modal_sheet_route.dart';
import 'package:rework_experiments/navigation/wolt_navigator.dart';

/// Main widget to show [WoltModalSheet] and use [WoltNavigator].
/// It is important to pass all supported pages that can be displayed in the [WoltModalSheet].
class WoltModalSheet extends StatefulWidget {
  final List<WoltModalSheetRoute> supportedPages;
  final List<WoltModalSheetPath> initialPage;

  const WoltModalSheet({
    super.key,
    required this.supportedPages,
    required this.initialPage,
  });

  @override
  State<WoltModalSheet> createState() => _WoltModalSheetState();
}

class _WoltModalSheetState extends State<WoltModalSheet> {
  late final WoltModalSheetCoordinator coordinator;

  @override
  void initState() {
    super.initState();
    coordinator = WoltModalSheetCoordinator();
    coordinator.init(widget.supportedPages, widget.initialPage);
  }

  @override
  Widget build(BuildContext context) {
    return WoltNavigator(
      coordinator: coordinator,
      child: _NavigationStack(
        changePagesNotifier: coordinator.changePagesNotifier,
      ),
    );
  }
}

class _NavigationStack extends StatelessWidget {
  final ValueNotifier<List<Page>> changePagesNotifier;

  const _NavigationStack({
    required this.changePagesNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return ValueListenableBuilder(
      valueListenable: changePagesNotifier,
      builder: (context, listPages, child) => Navigator(
        key: navigatorKey,
        pages: listPages,
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          } else {
            return true;
          }
        },
      ),
    );
  }
}
