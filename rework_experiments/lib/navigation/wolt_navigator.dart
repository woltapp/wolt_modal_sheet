import 'package:flutter/material.dart';
import 'package:rework_experiments/navigation/wolt_modal_sheet_coordinator.dart';
import 'package:rework_experiments/navigation/wolt_modal_sheet_path.dart';
import 'package:rework_experiments/navigation/wolt_modal_sheet.dart';

/// Point of interaction with the navigation inside the [WoltModalSheet].
class WoltNavigator<T> extends InheritedWidget {
  final WoltModalSheetCoordinator _coordinator;

  const WoltNavigator({
    super.key,
    required super.child,
    required WoltModalSheetCoordinator coordinator,
  }) : _coordinator = coordinator;

  @override
  bool updateShouldNotify(covariant WoltNavigator oldWidget) {
    return _coordinator != oldWidget._coordinator;
  }

  static WoltNavigator of(BuildContext context) {
    return _of(context);
  }

  static WoltNavigator _of(BuildContext context) {
    final result =
        context.getElementForInheritedWidgetOfExactType<WoltNavigator>();

    assert(result != null, 'No WoltNavigator found in context');

    return result!.widget as WoltNavigator;
  }

  void push(WoltModalSheetPath path) => _coordinator.push(path);

  void pushNamed(String name, [Object? arguments]) => _coordinator.push(
        WoltModalSheetPath(
          name: name,
          arguments: arguments,
        ),
      );

  void pop() => _coordinator.pop();

  void replaceAll(List<WoltModalSheetPath> paths) =>
      _coordinator.replaceAll(paths);
}
