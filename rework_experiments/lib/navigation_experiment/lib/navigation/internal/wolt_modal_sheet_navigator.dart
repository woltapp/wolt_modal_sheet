import 'package:flutter/material.dart';
import 'package:rework_experiments/navigation_experiment/lib/navigation/internal/wolt_modal_sheet_coordinator.dart';
import 'package:rework_experiments/navigation_experiment/lib/navigation/internal/wolt_modal_sheet_path.dart';
import 'package:rework_experiments/navigation_experiment/lib/wolt_modal_sheet.dart';

/// Point of interaction with [WoltModalSheet]s navigation internally
/// (from the shown content).
/// WoltModalSheetNavigator.of(context) is the way to reach it.
class WoltModalSheetNavigator extends InheritedWidget {
  final WoltModalSheetCoordinator _coordinator;

  const WoltModalSheetNavigator({
    super.key,
    required super.child,
    required WoltModalSheetCoordinator coordinator,
  }) : _coordinator = coordinator;

  @override
  bool updateShouldNotify(WoltModalSheetNavigator oldWidget) {
    return _coordinator != oldWidget._coordinator;
  }

  static WoltModalSheetNavigator of(BuildContext context) {
    final result = context
        .getElementForInheritedWidgetOfExactType<WoltModalSheetNavigator>();

    assert(result != null, 'No WoltNavigator found in context');

    return result!.widget as WoltModalSheetNavigator;
  }

  void push(WoltModalSheetPath path) {
    _coordinator.push(path);
  }

  void pushNamed(
    String name, [
    Object? arguments,
  ]) {
    _coordinator.push(
      WoltModalSheetPath(
        path: name,
        arguments: arguments,
      ),
    );
  }

  void pop() {
    _coordinator.pop();
  }

  void replaceAll(List<WoltModalSheetPath> paths) {
    _coordinator.replaceAll(paths);
  }
}
