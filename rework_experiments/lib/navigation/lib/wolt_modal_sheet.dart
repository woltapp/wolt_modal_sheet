import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_coordinator.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_navigator.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_path_settings.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_path.dart';

/// Main widget to show [WoltModalSheet] and use [WoltModalSheetNavigator].
/// It is important to pass all supported pages that can be displayed in the [WoltModalSheet].
class WoltModalSheet extends StatefulWidget {
  final List<WoltModalSheetPathSettings> supportedPaths;
  final List<WoltModalSheetPath> initialPath;
  final Function(List<WoltModalSheetPath>)? onPathChangedInternal;

  const WoltModalSheet({
    super.key,
    this.onPathChangedInternal,
    required this.supportedPaths,
    required this.initialPath,
  });

  @override
  State<WoltModalSheet> createState() => _WoltModalSheetState();
}

class _WoltModalSheetState extends State<WoltModalSheet> {
  late final WoltModalSheetCoordinator _coordinator;

  @override
  void initState() {
    super.initState();
    _coordinator = WoltModalSheetCoordinator(_onPathChanged);
    _coordinator.init(widget.supportedPaths, widget.initialPath);
  }

  @override
  void didUpdateWidget(covariant WoltModalSheet oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialPath != widget.initialPath) {
      _coordinator.actualizeNavigationStack(widget.initialPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: WoltModalSheetNavigator(
        coordinator: _coordinator,
        child: _NavigationStack(
          changePagesNotifier: _coordinator.pagesPublisher,
        ),
      ),
    );
  }

  void _onPathChanged(List<WoltModalSheetPath> path) {
    widget.onPathChangedInternal?.call(path);
  }
}

class _NavigationStack extends StatefulWidget {
  final ValueListenable<List<Page>> changePagesNotifier;

  const _NavigationStack({
    required this.changePagesNotifier,
  });

  @override
  State<_NavigationStack> createState() => _NavigationStackState();
}

class _NavigationStackState extends State<_NavigationStack> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.changePagesNotifier,
      builder: (context, listPages, child) => Navigator(
        key: _navigatorKey,
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
