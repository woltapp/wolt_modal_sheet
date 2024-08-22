import 'dart:async';

import 'package:coffee_maker_navigator_2/app/router/entities/app_route_configuration.dart';
import 'package:coffee_maker_navigator_2/app/router/entities/app_route_path.dart';
import 'package:coffee_maker_navigator_2/app/router/view/app_route_observer.dart';
import 'package:coffee_maker_navigator_2/app/router/view_model/router_view_model.dart';
import 'package:flutter/material.dart';

class AppRouterDelegate extends RouterDelegate<AppRouteConfiguration>
    with ChangeNotifier {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final RouterViewModel routerViewModel;

  AppRouterDelegate(this.routerViewModel) {
    routerViewModel.navigationStack.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: routerViewModel.navigationStack.value.pages,
      onPopPage: (route, result) {
        routerViewModel.onPagePoppedImperatively();
        return route.didPop(result);
      },
      observers: [AppRouteObserver(Theme.of(context).colorScheme)],
    );
  }

  /// The pops caused by Android swipe gesture and hardware button
  /// is handled in here instead of [Navigator]'s onPopPage callback.
  @override
  Future<bool> popRoute() {
    final currentContext = navigatorKey.currentContext;
    if (currentContext != null) {
      return routerViewModel.onPagePoppedWithOperatingSystemIntent();
    }

    return Future.value(false);
  }

  @override
  AppRouteConfiguration get currentConfiguration {
    final lastPage = routerViewModel.navigationStack.value.lastPage;
    return lastPage.configuration ??
        const AppRouteConfiguration(appRoutePath: AppRoutePath.bootstrap);
  }

  @override
  // ignore: no-empty-block, nothing to do
  Future<void> setNewRoutePath(AppRouteConfiguration configuration) async {
    routerViewModel.onNewRoutePathSet(configuration);
  }
}
