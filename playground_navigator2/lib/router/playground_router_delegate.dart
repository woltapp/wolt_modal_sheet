import 'dart:async';

import 'package:flutter/material.dart';
import 'package:playground_navigator2/bloc/router_cubit.dart';
import 'package:playground_navigator2/bloc/router_state.dart';
import 'package:playground_navigator2/router/playground_router_configuration.dart';
import 'package:playground_navigator2/router/router_pages/home_page.dart';
import 'package:playground_navigator2/router/router_pages/sheet_page.dart';
import 'package:playground_navigator2/router/router_pages/unknown_page.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class PlaygroundRouterDelegate
    extends RouterDelegate<PlaygroundRouterConfiguration>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<PlaygroundRouterConfiguration> {
  PlaygroundRouterDelegate({
    required RouterCubit cubit,
    required ValueNotifier<int> pageIndexNotifier,
    required ValueNotifier<WoltModalSheetPageListBuilder>
        pageListBuilderNotifier,
  })  : _cubit = cubit,
        _pageIndexNotifier = pageIndexNotifier,
        _pageListBuilderNotifier = pageListBuilderNotifier {
    _cubitSubscription = _cubit.stream.listen((state) {
      notifyListeners(); // Notify router that configuration has changed whenever the state updates
    });
  }

  final RouterCubit _cubit;
  late final StreamSubscription<RouterState> _cubitSubscription;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  final ValueNotifier<int> _pageIndexNotifier;
  final ValueNotifier<WoltModalSheetPageListBuilder> _pageListBuilderNotifier;

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    final state = _cubit.state;
    List<Page> pages = [const HomePage()];
    if (state is ModalSheetVisibleState) {
      _pageIndexNotifier.value = state.pageIndex;
      _pageListBuilderNotifier.value = state.pathName.pageListBuilder;
      pages = [
        const HomePage(),
        SheetPage(
          pageIndexNotifier: _pageIndexNotifier,
          pageListBuilderNotifier: _pageListBuilderNotifier,
        ),
      ];
    } else if (state is UnknownScreenVisibleState) {
      pages = [const UnknownPage()];
    }
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        return true;
      },
    );
  }

  @override
  Future<bool> popRoute() async {
    if (_navigatorKey.currentState != null &&
        _navigatorKey.currentState!.canPop()) {
      _navigatorKey.currentState!.pop();
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  PlaygroundRouterConfiguration get currentConfiguration {
    final state = _cubit.state;
    if (state is UnknownScreenVisibleState) {
      return PlaygroundRouterConfiguration.unknown();
    } else if (state is ModalSheetVisibleState) {
      _pageIndexNotifier.value = state.pageIndex;
      _pageListBuilderNotifier.value = state.pathName.pageListBuilder;
      return PlaygroundRouterConfiguration.modalSheet(
        multiPagePathName: state.pathName,
        index: state.pageIndex,
      );
    } else {
      return PlaygroundRouterConfiguration.home();
    }
  }

  @override
  Future<void> setNewRoutePath(
      PlaygroundRouterConfiguration configuration) async {
    if (configuration.isUnknown) {
      _cubit.showOnUnknownScreen();
    } else if (configuration.isHomePage) {
      _cubit.closeSheet();
    } else if (configuration.isSheetPage) {
      _cubit.onPathAndPageIndexUpdated(
          configuration.multiPagePathName!, configuration.pageIndex);
    }
  }

  @override
  void dispose() {
    _cubitSubscription.cancel();
    super.dispose();
  }
}
