import 'package:flutter/material.dart';
import 'package:rework_experiments/navigation/wolt_modal_sheet_route.dart';
import 'package:rework_experiments/navigation/wolt_modal_sheet_path.dart';

/// Navigation coordination point in the application.
class WoltModalSheetCoordinator {
  final ValueNotifier<List<Page>> _changePagesNotifier =
      ValueNotifier<List<Page>>(<Page>[]);

  ValueNotifier<List<Page>> get changePagesNotifier => _changePagesNotifier;

  late final List<WoltModalSheetRoute> _supportedPages;

  WoltModalSheetCoordinator();

  /// Makes initialization of the coordinator.
  /// Register available routes and initial state of the navigation stack.
  void init(
    List<WoltModalSheetRoute> allPages,
    List<WoltModalSheetPath> initialPath,
  ) {
    _supportedPages = allPages;
    final initialPage = <Page>[];
    for (WoltModalSheetPath path in initialPath) {
      initialPage.add(_buildPage(path));
    }

    _changePagesNotifier.value = initialPage;
  }

  void push(WoltModalSheetPath path) {
    if (!(_supportedPages
        .contains(_supportedPages.firstWhere((page) => page.name == path.name)))) {
      throw Exception(
          'Unregistered path ${path.name}. Please register the path to the list of supported pages ');
    }

    final currentListPages = _changePagesNotifier.value;

    currentListPages.add(_buildPage(path));

    _changePagesNotifier.value = currentListPages.toList();
  }

  void pop() {
    final currentListPages = _changePagesNotifier.value;
    if (currentListPages.length > 1) {
      currentListPages.removeLast();
      _changePagesNotifier.value = currentListPages.toList();
    }
  }

  void replaceAll(List<WoltModalSheetPath> paths) {
    final currentListPages = _changePagesNotifier.value;
    currentListPages.clear();
    for (WoltModalSheetPath path in paths) {
      if (!_supportedPages
          .contains(_supportedPages.where((page) => page.name == path.name))) {
        throw Exception(
            'Unregistered path $path. Please register the path to the list of supported pages ');
      }

      currentListPages.add(_buildPage(path));
    }

    _changePagesNotifier.value = currentListPages.toList();
  }

  Page _buildPage(WoltModalSheetPath path) {
    return _supportedPages
        .firstWhere((page) => page.name == path.name)
        .pageBuilder(path.arguments);
  }
}
