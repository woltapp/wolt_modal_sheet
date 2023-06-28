import 'dart:async';

import 'package:flutter/material.dart';
import 'package:playground_navigator2/bloc/playground_cubit.dart';
import 'package:playground_navigator2/bloc/playground_state.dart';
import 'package:playground_navigator2/router/playground_router_configuration.dart';
import 'package:playground_navigator2/router/router_pages/home_page.dart';
import 'package:playground_navigator2/router/router_pages/sheet_page.dart';
import 'package:playground_navigator2/router/router_pages/unknown_page.dart';
class PlaygroundRouterDelegate extends RouterDelegate<PlaygroundRouterConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PlaygroundRouterConfiguration> {

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  PlaygroundRouterDelegate(this._cubit) {
    _cubitSubscription = _cubit.stream.listen((state) {
      notifyListeners(); // Notify router that configuration has changed whenever the state updates
    });
  }

  final PlaygroundCubit _cubit;
  late final StreamSubscription<PlaygroundState> _cubitSubscription;

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    final state = _cubit.state;
    List<Page> pages = [const HomePage()];
    if (state is PlaygroundSheetVisibleState) {
      pages = [
        const HomePage(),
        SheetPage(
          pageIndexNotifier: _cubit.pageIndexNotifier,
          pageListBuilderNotifier: _cubit.pageListBuilderNotifier,
          modalTypeBuilder: _cubit.modalTypeBuilder,
        ),
      ];
    } else if (state is PlaygroundUnknownScreenState) {
      pages = [const UnknownPage()];
    }
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        if (route.settings.name == SheetPage.routeName) {
          _cubit.closeSheet();
        }
        return true;
      },
    );
  }

  @override
  Future<bool> popRoute() async {
    if (_navigatorKey.currentState != null && _navigatorKey.currentState!.canPop()) {
      _navigatorKey.currentState!.pop();
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  PlaygroundRouterConfiguration get currentConfiguration {
    final state = _cubit.state;
    if (state is PlaygroundUnknownScreenState) {
      return PlaygroundRouterConfiguration.unknown();
    } else if (state is PlaygroundSheetVisibleState) {
      return PlaygroundRouterConfiguration.modalSheet(
        multiPagePathName: state.pathName,
        index: state.pageIndex,
      );
    } else {
      return PlaygroundRouterConfiguration.home();
    }
  }

  @override
  Future<void> setNewRoutePath(PlaygroundRouterConfiguration configuration) async {
    if (configuration.isUnknown) {
      // Handle unknown route
    } else if (configuration.isHomePage) {
      _cubit.closeSheet();
    } else if (configuration.isSheetPage) {
      _cubit.onPathUpdated(configuration.multiPagePathName!);
    }
  }

  @override
  void dispose() {
    _cubitSubscription.cancel();
    // _cubit.close();  // Don't close the cubit here
    super.dispose();
  }
}

