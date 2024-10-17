import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_path_settings.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_path.dart';

/// Navigation coordination point in the application.
class WoltModalSheetCoordinator {
  final void Function(List<WoltModalSheetPath>) _onPathChangedInternal;
  final _pages = ValueNotifier<List<Page>>(<Page>[]);

  ValueListenable<List<Page>> get pagesPublisher => _pages;
  final _supportedPaths = <WoltModalSheetPathSettings>{};
  final _currentPaths = <WoltModalSheetPath>[];

  WoltModalSheetCoordinator(this._onPathChangedInternal);

  /// Makes initialization of the coordinator.
  /// Register available routes and initial state of the navigation stack.
  void init(
    List<WoltModalSheetPathSettings> supportedPaths,
    List<WoltModalSheetPath> initialPath,
  ) {
    _supportedPaths.clear();
    _supportedPaths.addAll(supportedPaths);
    _currentPaths.clear();
    _currentPaths.addAll(initialPath);

    final initialPages = <Page>[];
    for (WoltModalSheetPath path in _currentPaths) {
      initialPages.add(_buildPage(path));
    }

    _pages.value = initialPages;
  }

  void push(WoltModalSheetPath path) {
    if (!_isPathSupported(path)) {
      throw Exception(
          'Unregistered path ${path.path}. Please register the path to the list of supported pages');
    }
    _currentPaths.add(path);

    final currentListPages = _pages.value.toList();
    currentListPages.add(_buildPage(path));

    _pages.value = currentListPages;
    _onPathChangedInternal(_currentPaths);
  }

  void pop() {
    if (_pages.value.length > 1) {
      final currentListPages = _pages.value.toList()..removeLast();
      _currentPaths.removeLast();
      _pages.value = currentListPages;
      _onPathChangedInternal(_currentPaths);
    } else {}
  }

  void replaceAll(List<WoltModalSheetPath> paths) {
    final currentListPages = <Page>[];
    for (WoltModalSheetPath path in paths) {
      if (!_isPathSupported(path)) {
        throw Exception(
            'Unregistered path ${path.path}. Please register the path to the list of supported pages');
      }

      currentListPages.add(_buildPage(path));
    }

    _pages.value = currentListPages;
  }

  void actualizeNavigationStack(List<WoltModalSheetPath> updatedPaths) {
    _currentPaths.clear();
    _currentPaths.addAll(updatedPaths);

    final currentPages = <Page>[];
    for (WoltModalSheetPath path in _currentPaths) {
      currentPages.add(_buildPage(path));
    }

    _pages.value = currentPages;
  }

  Page _buildPage(WoltModalSheetPath path) {
    return _supportedPaths
        .firstWhere((page) => page.path == path.path)
        .pageBuilder(path.arguments);
  }

  bool _isPathSupported(WoltModalSheetPath path) {
    final supportedPath = _supportedPaths
        .firstWhereOrNull((checking) => path.path == checking.path);

    return supportedPath != null;
  }
}
